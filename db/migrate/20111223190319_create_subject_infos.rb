class CreateSubjectInfos < ActiveRecord::Migration
  def change
    create_table :subject_infos do |t|
      t.string :room
      t.integer :year
      t.references :subject

      t.timestamps
    end
  end
end
