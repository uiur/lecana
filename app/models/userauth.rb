class Userauth < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :provider, :scope => [:user_id]
end
