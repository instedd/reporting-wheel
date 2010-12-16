class AddPoolIdToWheel < ActiveRecord::Migration
  def self.up
    add_column :wheels, :pool_id, :integer
    
    # Make default Pool
    pool = Pool.create! :name => "Default", :description => "Default Pool"
    
    Wheel.all.each do |wheel|
      wheel.pool = pool
      wheel.save!
    end
  end

  def self.down
    remove_column :wheels, :pool_id
  end
end
