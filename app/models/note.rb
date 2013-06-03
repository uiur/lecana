class Note < ActiveRecord::Base
  belongs_to :subject
  belongs_to :user
  has_many :favs, :as => :favable, :dependent => :destroy

  validates :content, :presence => true
  validates :user_id, :presence => true

  default_scope :order => 'created_at DESC'
  scope :recents, lambda {|subject| where(:subject_id => subject.id) }

  after_create :add_activity_create

  def to_html
    RedCloth.new(self.content, [:filter_html]).to_html
  end

  def self.recent(subject)
    self.recents(subject).first
  end

  def self.authors(subject)
    self.recents(subject).map(&:user).uniq
  end

  def faved_by(user)
    Fav.find_by_user_and_favable(user, self).first
  end

  private
  def add_activity_create
    Activity.add(self.user, Activity::Note::CREATED, self, self.subject)
  end
end
