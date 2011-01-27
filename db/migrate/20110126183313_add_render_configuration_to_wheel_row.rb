class AddRenderConfigurationToWheelRow < ActiveRecord::Migration
  def self.up
    add_column :wheel_rows, :render_configuration, :text
  end

  def self.down
    remove_column :wheel_rows, :render_configuration
  end
end
