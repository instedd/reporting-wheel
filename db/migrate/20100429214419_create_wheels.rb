class CreateWheels < ActiveRecord::Migration
  def self.up
    create_table :wheels do |t|
      t.string :name
      t.integer :factor0
      t.integer :factor1
      t.integer :factor2

      t.timestamps
    end
  end

  def self.down
    drop_table :wheels
  end
end
