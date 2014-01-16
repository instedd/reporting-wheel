class AddValuesToWheelRecord < ActiveRecord::Migration
  def self.up
    add_column :wheel_records, :values, :text
  end

  def self.down
    remove_column :wheel_records, :values
  end
end
