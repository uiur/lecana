class RemoveFacultyIdAndCollegeIdFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :college_id
    remove_column :users, :faculty_id
  end

  def down
    add_column :users, :college_id
    add_column :users, :faculty_id
    add_index :users, :college_id
    add_index :users, :faculty_id
  end
end
