# encoding: UTF-8
module ApplicationHelper
  module Const
    DAYS = %w{日 月 火 水 木 金 土}
    DEFAULT_IMAGE = 'http://a0.twimg.com/sticky/default_profile_images/default_profile_1_bigger.png'
  end
  include Const

  def user_path(user)
    name = user.name rescue user
    super(name)
  end

  def day(n)
    DAYS[n]
  end

  def user_image(user, option={})
    image_tag profile_image_url(user), option
  end

  def current_user_image(option={})
    user_image(current_user, option)
  end

  def profile_image_url(user)
    user.image_url || DEFAULT_IMAGE
  end

  def link_to_user(user, option={})
    link_to user.name, user_path(user), option
  end

  def image_link_to_user(user, image_option={}, option={})
    link_to user_image(user, image_option), user_path(user), option
  end

  def link_to_subject(subject, option={})
    link_to subject.name, subject_path(subject), option
  end

  def format_time(time)
    time.strftime("%Y-%m-%d %H:%M:%S")
  end

  def activity_label(activity)
    suffix = case activity.activity_type
    when Activity::Post::CREATED
      'に投稿しました'
    when Activity::Review::CREATED
      'にレビューを投稿しました'
    when Activity::Subject::REGISTERD
      'を時間割に登録しました'
    when Activity::Note::CREATED
      'のパブリックノートを編集しました'
    when Activity::File::UPLOADED
      'にファイルをアップロードしました'
    end
    activity_label_user_subject(activity, suffix)
  end

  def add_fav_path(favable)
    send("#{favable.class.name.downcase}_favs_path".to_sym, favable)
  end

  def remove_fav_path(fav)
    send("#{fav.favable.class.name.downcase}_fav_path".to_sym, fav.favable, fav)
  end
  
  # userのTwitter or Facebookページにリンクする
  def link_to_user_external(user, option={})
    url = case user.auth.provider
    when 'twitter'
      'https://twitter.com/' + user.name
    when 'facebook'
      'https://facebook.com/' + user.name
    end
    
    link_to user.name, url, option
  end
  
  # サイドバーを表示しない
  def no_sidebar
    # '42'の部分は空白文字以外ならなんでもよい
    content_for :no_sidebar, '42'
  end

  private
  def activity_label_user_subject(activity, content)
      (link_to_subject activity.target2) + content
  end
end

