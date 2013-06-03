# encoding: UTF-8

# SubjectInfo: 科目の基本情報
#   room: 教室
#   year: 年度
#   subject_id: reference
#
#-- association:
#     users, periods
#     terms: 学期
class SubjectInfo < ActiveRecord::Base
  has_and_belongs_to_many :periods
  belongs_to :subject
  has_many :subject_infos_users
  has_many :users, :through => :subject_infos_users
  has_many :info_terms
  has_many :terms, :through => :info_terms

  accepts_nested_attributes_for :periods
  accepts_nested_attributes_for :terms

  validates :year, presence: true
  #validates_uniqueness_of :year, :scope => [:subject_id]

  def name
    self.subject.name
  end

  def teacher_names
    self.subject.teacher_names
  end
end
