class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.references :user
      t.references :subject
      t.integer :rating
      t.text :content

      t.timestamps
    end
    add_index :reviews, :user_id
    add_index :reviews, :subject_id
  end
end
