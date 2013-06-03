# 学部
# example. name: 工学部 name2: 情報学科
class Faculty < ActiveRecord::Base
  belongs_to :college
  has_many :settings

  validates :name, presence: true

  def to_s
    [self.name, self.name2].join
  end
end
