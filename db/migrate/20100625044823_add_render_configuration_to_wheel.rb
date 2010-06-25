class AddRenderConfigurationToWheel < ActiveRecord::Migration
  def self.up
    add_column :wheels, :render_configuration, :text
  end

  def self.down
    remove_column :wheels, :render_configuration
  end
end
