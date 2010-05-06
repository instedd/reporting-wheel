class AddMultipleFactors < ActiveRecord::Migration
  def self.up
    add_column :wheels, :factors, :string
    remove_column :wheels, :factor0
    remove_column :wheels, :factor1
    remove_column :wheels, :factor2
  end

  def self.down
  end
end
