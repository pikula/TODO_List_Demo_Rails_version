class AddTimeZoneToUsers < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.string :time_zone, :default => "Zagreb"
    end
    User.update_all ["time_zone = ?", "Zagreb"]
  end
 
  def down
    remove_column :users, :time_zone
  end
end
