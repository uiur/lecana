class CreatePeriodsSubjectInfos < ActiveRecord::Migration
  def change
    create_table :periods_subject_infos, :id => false do |t|
      t.references :period
      t.references :subject_info
    end
    add_index :periods_subject_infos, :period_id
    add_index :periods_subject_infos, :subject_info_id
  end
end
