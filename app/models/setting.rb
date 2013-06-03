class Setting < ActiveRecord::Base
  belongs_to :faculty
  belongs_to :college
  belongs_to :user

  validates :faculty_id, :presence => true
  validates :college_id, :presence => true
  validates :user_id, :presence => true
  validates :entered_at, :presence => true
end
