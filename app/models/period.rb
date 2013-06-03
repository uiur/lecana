# encoding: UTF-8

# Period: 曜時限
#
#   day: 曜日 (日~土 - 0~6)
#   ord: 時限 (0~9)
#   (ただしday: 0, ord: 0はその他)
class Period < ActiveRecord::Base
  has_and_belongs_to_many :subject_infos

  validates :day, :presence => true, :inclusion => {:in => 0..6}
  validates :ord, :presence => true, :inclusion => {:in => 0..9}
  validates_uniqueness_of :ord, :scope => [:day]

  scope :ranged, lambda {|days, ords| where(:day => days, :ord => ords)}

  module Const
    DAYS = %w{日 月 火 水 木 金 土}.freeze
    OTHER = {day: 0, ord: 0}.freeze
  end
  include Const

  def to_s(type=:normal)
    return "その他" if self.day == 0 && self.ord == 0
    case type
    when :short
      "#{DAYS[self.day]}#{self.ord}"
    when :normal
      "#{DAYS[self.day]}曜#{self.ord}限"
    end
  end

  # HashからPeriodオブジェクトへの変換
  # {day: ?, ord: ?} -> Period
  def self.detect(attributes)
    self.where(attributes).first
  end
end
