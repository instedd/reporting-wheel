class ClearWheelRecordValues < ActiveRecord::Migration
  def self.up
    execute "UPDATE wheel_records SET `values` = NULL"
  end

  def self.down
  end
end
