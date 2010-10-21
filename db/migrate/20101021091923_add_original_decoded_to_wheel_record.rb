class AddOriginalDecodedToWheelRecord < ActiveRecord::Migration
  def self.up
    add_column :wheel_records, :original, :string
    add_column :wheel_records, :decoded, :string
  end

  def self.down
    remove_column :wheel_records, :original
    remove_column :wheel_records, :decoded
  end
end
