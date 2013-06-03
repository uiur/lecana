class CreateFaculties < ActiveRecord::Migration
  def change
    create_table :faculties do |t|
      t.string :name
      t.string :name2
      t.references :college

      t.timestamps
    end
    add_index :faculties, :college_id
  end
end
