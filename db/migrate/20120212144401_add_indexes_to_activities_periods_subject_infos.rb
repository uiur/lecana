class AddIndexesToActivitiesPeriodsSubjectInfos < ActiveRecord::Migration
  def change
    add_index :activities, ["activity_type", "target_id"]
    add_index :periods, ["day", "ord"]
    add_index :subject_infos, "subject_id"
  end
end
