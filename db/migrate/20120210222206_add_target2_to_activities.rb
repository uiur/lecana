class AddTarget2ToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :target2_id, :integer
    add_column :activities, :target2_type, :string
  end
end
