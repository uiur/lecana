class AddCollegeIdAndFacultyIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :college_id, :integer
    add_column :users, :faculty_id, :integer

    add_index :users, [:college_id, :faculty_id]
  end
end
