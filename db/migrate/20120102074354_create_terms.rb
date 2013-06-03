class CreateTerms < ActiveRecord::Migration
  def change
    create_table :terms do |t|
      t.integer :ord

      t.timestamps
    end
  end
end
