class AddMultipleFactors < ActiveRecord::Migration
  def self.up
    add_column :wheels, :factors, :string
    remove_column :wheels, :factor0
    remove_column :wheels, :factor1
    remove_column :wheels, :factor2
  end

  def self.down
    remove_column :wheels, :factors
    add_column :wheels, :factor0, :integer
    add_column :wheels, :factor1, :integer
    add_column :wheels, :factor2, :integer
  end
end
