class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :activity_type
      t.integer :target_id
      t.string :target_type
      t.references :user

      t.timestamps
    end
    add_index :activities, :user_id
  end
end
