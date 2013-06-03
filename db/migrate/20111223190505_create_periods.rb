class CreatePeriods < ActiveRecord::Migration
  def change
    create_table :periods do |t|
      t.integer :day
      t.integer :ord

      t.timestamps
    end
  end
end
