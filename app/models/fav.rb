# favable : Post, Review
class Fav < ActiveRecord::Base
  belongs_to :user
  belongs_to :favable, :polymorphic => true
  validates_uniqueness_of :user_id, :scope => [:favable_id, :favable_type]

  def self.find_by_user_and_favable(user, favable)
    self.where(user_id: user.id, favable_id: favable.id, favable_type: favable.class.to_s)
  end
end
