class CreateVoiceChannels < ActiveRecord::Migration
  def self.up
    create_table :voice_channels do |t|
      t.string :number
      t.string :language

      t.timestamps
    end
  end

  def self.down
    drop_table :voice_channels
  end
end
