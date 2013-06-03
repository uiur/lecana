class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.references :faculty
      t.references :college
      t.references :user
      t.integer :entered_at

      t.timestamps
    end
    add_index :settings, :faculty_id
    add_index :settings, :college_id
    add_index :settings, :user_id
  end
end
