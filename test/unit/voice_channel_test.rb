require 'test_helper'

class VoiceChannelTest < ActiveSupport::TestCase
  
  def setup
    @voice_channel = VoiceChannel.new :number => '12345678', :language => 'en-EN'
  end
  
  test "should be valid with valid attributes" do
    assert @voice_channel.valid?
  end
end
