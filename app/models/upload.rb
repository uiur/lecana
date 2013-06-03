require 'file_size_validator'
class Upload < ActiveRecord::Base
  attr_accessible :file, :name
  belongs_to :subject
  belongs_to :user
  has_many :activities, :as => :target, :dependent => :destroy

  mount_uploader :file, FileUploader
  validates :file, :presence => true, :file_size => { :maximum => 30.megabytes.to_i }
  validates :name, :presence => true

  after_create :add_activity_create

  private
  def add_activity_create
    Activity.add(self.user, Activity::File::UPLOADED, self, self.subject)
  end
end
