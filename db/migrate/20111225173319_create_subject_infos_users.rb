class CreateSubjectInfosUsers < ActiveRecord::Migration
  def change
    create_table :subject_infos_users do |t|
      t.references :subject_info
      t.references :user

      t.timestamps
    end
    add_index :subject_infos_users, :subject_info_id
    add_index :subject_infos_users, :user_id
  end
end
