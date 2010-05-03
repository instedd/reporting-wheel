class CreateWheelRows < ActiveRecord::Migration
  def self.up
    create_table :wheel_rows do |t|
      t.integer :index
      t.string :label
      t.references :wheel

      t.timestamps
    end
  end

  def self.down
    drop_table :wheel_rows
  end
end
