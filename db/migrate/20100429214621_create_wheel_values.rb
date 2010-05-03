class CreateWheelValues < ActiveRecord::Migration
  def self.up
    create_table :wheel_values do |t|
      t.integer :index
      t.string :value
      t.integer :code
      t.references :wheel_row

      t.timestamps
    end
  end

  def self.down
    drop_table :wheel_values
  end
end
