class AddAllowFreeTextToWheel < ActiveRecord::Migration
  def self.up
    add_column :wheels, :allow_free_text, :bool, :default => false
  end

  def self.down
    remove_column :wheels, :allow_free_text
  end
end