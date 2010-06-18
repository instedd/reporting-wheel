class AddOkTextToWheel < ActiveRecord::Migration
  def self.up
    add_column :wheels, :ok_text, :string
  end

  def self.down
    remove_column :wheels, :ok_text
  end
end
