# encoding: UTF-8
class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :postable, :polymorphic => true
  has_one :activity, :as => :target, :dependent => :destroy
  has_many :favs, :as => :favable, :dependent => :destroy

  validates :user_id, :presence => true
  validates :content, :presence => true, :length => { :maximum  => 200 }

  default_scope order('created_at DESC')

  after_create :add_activity_create

  attr_reader :do_post_to_external

  def faved_by(user)
    Fav.find_by_user_and_favable(user, self).first
  end
  
  # alias
  def subject
    postable
  end

  private
  def add_activity_create
    Activity.add(self.user, Activity::Post::CREATED, self, self.postable)
  end
end
