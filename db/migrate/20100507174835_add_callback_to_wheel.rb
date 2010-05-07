class AddCallbackToWheel < ActiveRecord::Migration
  def self.up
    add_column :wheels, :url_callback, :string
  end

  def self.down
    remove_column :wheels, :url_callback
  end
end
