class CreateSubjectsTeachers < ActiveRecord::Migration
  def change
    create_table :subjects_teachers, :id => false do |t|
      t.references :subject
      t.references :teacher
    end
  end
end
