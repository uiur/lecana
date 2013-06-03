class PatchToMysql < ActiveRecord::Migration
  def up
    if Rails.env == 'production'
      execute "CREATE FUNCTION random() RETURNS FLOAT NO SQL SQL SECURITY INVOKER RETURN rand();"
    end
  end

  def down
  end
end
