# encoding: UTF-8
# Term: 学期
class Term < ActiveRecord::Base
  has_many :info_terms
  has_many :subject_infos, :through => :info_terms

  validates :ord, :uniqueness => true

  scope :ranged, lambda{|r| where(ord: r) }
  scope :active, lambda{ ranged(0..2) }

  def to_s
    terms = %w{その他 前期 後期}
    terms[self.ord]
  end

  def self.detect(params={})
    self.find_by_ord(params[:ord])
  end
end
