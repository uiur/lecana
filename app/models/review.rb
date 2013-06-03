class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :subject
  has_one :activity, :as => :target, :dependent => :destroy
  has_many :favs, :as => :favable, :dependent => :destroy

  validates :user_id, :presence => true
  validates :subject_id, :presence => true
  validates :content, :presence => true, :length => { :maximum  => 400 }
  validates :rating, :presence => true, :numericality => { :greater_than_or_equal_to => 1, :less_than_or_equal_to => 5 }
  validates :rating2, :presence => true, :numericality => { :greater_than_or_equal_to => 1, :less_than_or_equal_to => 5 }

  after_create :add_activity_create

  default_scope order('created_at DESC')

  def faved_by(user)
    Fav.find_by_user_and_favable(user, self).first
  end

  private
  def add_activity_create
    Activity.add(self.user, Activity::Review::CREATED, self, self.subject)
  end
end
