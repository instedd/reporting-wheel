class CreateLocalGateways < ActiveRecord::Migration
  def self.up
    create_table :local_gateways do |t|
      t.integer :user_id
      t.string :name
      t.string :address

      t.timestamps
    end
  end

  def self.down
    drop_table :local_gateways
  end
end
