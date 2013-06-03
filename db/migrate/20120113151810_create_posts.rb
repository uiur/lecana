class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.references :user
      t.text :content
      t.references :postable, :polymorphic => true

      t.timestamps
    end
    add_index :posts, :user_id
    add_index :posts, :postable_id
  end
end
