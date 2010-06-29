class TwilioControllerTest < ActionController::TestCase
  
  test "should get hello in thai" do
    get(:hello, { :Called => "123456789" })
    
    assert_equal(@request.protocol + @request.host + VoiceChannel.responses_path + "/hello_th.mp3", 
      assigns(:hello_response))
  end
  
  test "should decode user report and respond accordingly" do
    
    wheel_combination = mock()
    WheelCombination.expects(:new).returns(wheel_combination)
    wheel_combination.expects(:record!)
    wheel_combination.expects(:wheel).returns(@wheel)
    
    get(:receive_code, { :Called => "123456789", :Digits => '019019019'})
    
    assert_equal(@request.protocol + @request.host + @wheel.success_voice_path, assigns(:success_message))
    assert_equal(false, assigns(:error))
  end
  
  test "should indicate error if couldnt decode" do
    WheelCombination.expects(:new).raises RuntimeError, 'An error occurred'
    
    get(:receive_code, twilio_metadata)
    
    assert_equal(true, assigns(:error))
    assert_equal(@request.protocol + @request.host + VoiceChannel.failure_response, assigns(:error_message))
  end
  
  def setup
    @voice_channel = VoiceChannel.new :number => 123456789, :language => "th" 
    @voice_channel.save!
    
    @wheel = mock()
          
    value1 = mock()
    row1 = mock()
    value2 = mock()
    row2 = mock()
    value3 = mock()
    row3 = mock()
    
    Wheel.stubs(:find_for_factors).with([19,19,19]).returns(@wheel)
    
    WheelValue.stubs(:find_for).with(@wheel,0,19).returns(value1)
    WheelValue.stubs(:find_for).with(@wheel,1,19).returns(value2)
    WheelValue.stubs(:find_for).with(@wheel,2,19).returns(value3)
    
    WheelRecord.stubs(:create!).returns(nil)
    
    value1.stubs(:row).returns(row1)
    row1.stubs(:label).returns('Label1')    
    value1.stubs(:value).returns('Value1')
    
    value2.stubs(:row).returns(row2)
    row2.stubs(:label).returns('Label2')
    value2.stubs(:value).returns('Value2')
        
    value3.stubs(:row).returns(row3)
    row3.stubs(:label).returns('Label3')
    value3.stubs(:value).returns('Value3')
    
    @wheel.stubs(:has_callback?).returns(true)
    @wheel.stubs(:url_callback).returns('http://www.domain.com/some/url')
    @wheel.stubs(:success_voice_path).returns('/wheels/1/audio/success_th.mp3')
  end
  
  def teardown
    VoiceChannel.delete(@voice_channel.id)
  end
  
  def twilio_metadata
    { :Called => "123456789", :Digits => "foo" }
  end  
  
end
