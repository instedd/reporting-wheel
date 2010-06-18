class AddWrongTextToWheel < ActiveRecord::Migration
  def self.up
    add_column :wheels, :wrong_text, :string
  end

  def self.down
    remove_column :wheels, :wrong_text
  end
end
