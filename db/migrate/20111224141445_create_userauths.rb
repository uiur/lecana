class CreateUserauths < ActiveRecord::Migration
  def change
    create_table :userauths do |t|
      t.string :provider
      t.string :uid
      t.string :name
      t.string :screen_name
      t.string :token
      t.string :secret
      t.references :user

      t.timestamps
    end
  end
end
