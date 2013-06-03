class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.text :content
      t.references :user
      t.references :subject

      t.timestamps
    end
    add_index :notes, :user_id
    add_index :notes, :subject_id
  end
end
