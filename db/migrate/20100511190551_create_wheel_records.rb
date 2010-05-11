class CreateWheelRecords < ActiveRecord::Migration
  def self.up
    create_table :wheel_records do |t|
      t.references :wheel
      t.string :code
      t.text :data
      
      t.timestamps
    end
  end

  def self.down
    drop_table :wheel_records
  end
end
