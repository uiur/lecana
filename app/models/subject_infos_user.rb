# encoding: UTF-8
class SubjectInfosUser < ActiveRecord::Base
  belongs_to :subject_info
  belongs_to :user
  
  after_create :add_activity_create

  private
  def add_activity_create
    Activity.add(self.user, Activity::Subject::REGISTERD, self.subject_info, self.subject_info.subject)
  end
end
