class College < ActiveRecord::Base
  has_many :subjects
  has_many :faculties
  has_many :settings

  validates :name, :presence => true

  def to_s
    self.name
  end
end
