class AddRating2ToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :rating2, :integer
  end
end
