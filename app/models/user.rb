# encoding: UTF-8
require 'uri'

class User < ActiveRecord::Base
  attr_accessible :name

  belongs_to :college
  belongs_to :faculty

  has_one :auth, :class_name => "Userauth", :dependent => :destroy
  has_many :subject_infos_users
  has_many :subject_infos, :through => :subject_infos_users
  has_many :posts
  has_many :reviews
  has_many :favs
  has_one :setting, :dependent => :destroy
  has_many :notes
  has_many :uploads
  has_many :activities

  validates :name, :format => { :with => /\A[0-9A-Za-z_\.]+\Z/ }, :uniqueness => true, :length => 2..20, :on => :update

  accepts_nested_attributes_for :college
  accepts_nested_attributes_for :faculty

  scope :registering, lambda {|subject, year=YEAR| joins(:subject_infos).where(:subject_infos => {:id => subject.info(year).id})}

  module Const
    REGISTER_LIMIT = 3

    module ExtPost
      BASE_URL = "http://lecana.net/"
      NAME = "Lecana"
      DESCRIPTION = "講義情報共有サービス"
    end
  end
  include Const

  include ActionView::Helpers::TextHelper

  def self.create_with_omniauth(auth)
    screen_name = auth["info"]["nickname"]
    if User.find_by_name(screen_name)
      screen_name = nil
    end

    u = User.create(name: screen_name)
    Userauth.create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
      user.screen_name = screen_name
      user.token = auth["credentials"]["token"]
      user.secret = auth["credentials"]["secret"]
      user.user_id = u.id
    end

    return u
  end

  # 時間割の似ているユーザー
  def self.similar_to(user, year=YEAR)
    User.find_by_sql(["SELECT U.* FROM (SELECT SU2.user_id, count(*) AS count FROM (subject_infos_users SU1 INNER JOIN subject_infos_users SU2 ON SU1.subject_info_id = SU2.subject_info_id) INNER JOIN subject_infos SI ON SU1.subject_info_id = SI.id WHERE SU1.user_id = ? AND SI.year = ? GROUP BY SU2.user_id) SU INNER JOIN users U ON SU.user_id=U.id WHERE U.id <> ? ORDER BY SU.count DESC LIMIT 15", user.id, year, user.id])
  end

  # 科目を登録する
  def register(subject_info)
    if register_limit?(subject_info)
      false
    else
      unless (self_subject_infos = self.subject_infos).include? subject_info
        self_subject_infos << subject_info
      end
      self.save
    end
  end

  # 科目を取り除く
  def remove(subject_info)
    self.subject_infos.delete(subject_info)
    self.save
  end

  # 科目を登録したかどうか
  def registered?(subject_info)
    self.subject_infos.where(id: subject_info.id).any?
  end

  def periods(year=YEAR)
    infos = self.subject_infos.where(year: year)

    ps = []
    infos.each do |info|
      ps += info.periods
    end

    ps.uniq
  end

  # 時間割表を返す
  # { Period => [Subject] }
  def timetable(term=TERM, year=YEAR)
    infos = self.subject_infos.joins(:terms).where(year: year, terms: { ord: term })

    table = Hash.new{|h,k| h[k] = []}
    infos.each do |info|
      info.periods.each do |period|
        table[period] << info
      end
    end

    table
  end

  # Settingへのアクセサ
  [:college, :faculty, :entered_at].each do |name|
    define_method name do
      self.setting && self.setting.send(name)
    end
  end

  # 名前を更新する
  def update_names!(auths)
    uauth = self.auth
    uauth.update_attributes(name: auths["info"]["name"], screen_name: auths["info"]["nickname"])
    self.update_attributes(name: uauth.screen_name)
  end 

  # 画像のURLを取得して更新する
  def update_image_url!
    url = fetch_image
    if url
      self.image_url = url
      self.save
    else
      false
    end
  end

  # 所有者かどうか
  def have?(stuff)
    stuff.user == self
  end

  # Postを投稿する
  def post(content, subject)
    self.posts.create(content: content, postable: subject)
  end

  # favする
  def fav(favable)
    self.favs.create(favable: favable)
  end

  def faved?(favable)
    Fav.find_by_user_and_favable(self, favable).any?
  end

  def subname
    self.auth.name
  end

  # Twitter OR facebookに投稿する
  # USAGE: @user.post_to_external(@post)
  #        @user.post_to_external(@review)
  def post_to_external(object)
    arg = {}
    arg[:message] = object.content
    arg[:link] = ExtPost::BASE_URL + (object.subject ? "subjects/#{object.subject.id}" : "")
    arg[:name] = ExtPost::NAME
    arg[:description] = ExtPost::DESCRIPTION

    begin
      case self.auth.provider
      when 'twitter'
        if object.is_a? Review
          text = "レビューを投稿しました：#{truncate object.content, :length => 24} / #{object.subject.name} - 講義情報共有サービス #{arg[:name]} #{arg[:link]}"
        elsif object.is_a? Post
          text = "コメントを投稿しました：#{truncate object.content, :length => 24} / #{object.subject ? object.subject.name + '- ' : ''}講義情報共有サービス #{arg[:name]} #{arg[:link]}"
        end
        post_to_twitter(text)
      when 'facebook'
        post_to_facebook(arg)
      end
    rescue
      nil
    end
  end
    
  private

  # Twitterにツイート
  def post_to_twitter(content)
    configure_twitter
    Twitter.update(content)
  end

  # facebookにpost
  def post_to_facebook(arg = {})
    me = FbGraph::User.me(self.auth.token)
    me.feed!(arg)
  end

  # 画像のURLを取ってくる
  def fetch_image
    case self.auth.provider
    when 'twitter'
      fetch_image_from_twitter
    when 'facebook'
      fetch_image_from_facebook
    end
  end

  def fetch_image_from_twitter
    configure_twitter
    begin 
      #memo: TwitterAPIの状況により取得できない場合がある
      Twitter.profile_image(self.auth.screen_name)
    rescue
      nil
    end
  end

  def fetch_image_from_facebook
    begin 
      user = FbGraph::User.me(self.auth.token)
      user = user.fetch
      user.picture
    rescue
      nil
    end
  end

  def configure_twitter
    Twitter.configure do |config|
      config.consumer_key = Settings.twitter_key
      config.consumer_secret = Settings.twitter_secret
      config.oauth_token = self.auth.token
      config.oauth_token_secret = self.auth.secret
    end
  end

  def register_limit?(subject_info)
    table = {}
    subject_info.terms.each do |term|
      table[term] = self.timetable(term.ord, subject_info.year)
    end

    subject_info.terms.any? {|term| subject_info.periods.any? { |period| table[term][period].size >= REGISTER_LIMIT }}
  end

end
