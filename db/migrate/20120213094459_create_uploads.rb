class CreateUploads < ActiveRecord::Migration
  def change
    create_table :uploads do |t|
      t.references :subject
      t.references :user
      t.string :name
      t.string :file

      t.timestamps
    end
    add_index :uploads, :subject_id
    add_index :uploads, :user_id
  end
end
