class TwilioControllerTest < ActionController::TestCase
  
  def setup
    @voice_channel = VoiceChannel.new :number => 123456789, :language => "th" 
    @voice_channel.save!
  end
  
  def teardown
    VoiceChannel.delete(@voice_channel.id)
  end
  
  def test_should_get_hello_in_thai
    get(:hello, { :Called => "123456789" })
    
    assert_equal(@controller.request.protocol + @controller.request.host + VoiceChannel.responses_path + "/hello_th.mp3", 
      assigns(:hello_response))
  end
end
