require 'test_helper'
require 'yaml'

class DecodeControllerTest < ActionController::TestCase
  
  test "should return error message in Thai" do
    @request.env['RAW_POST_DATA'] = 'foo'
    post(:wheel, :locale => 'th')
    
    assert_equal((I18n.t :wheel_error_message, :code => 'foo', :locale => 'th'), assigns(:message))
  end
  
  test "should return a GeoChat action reply header in case of an error" do
    @request.env['RAW_POST_DATA'] = 'foo'
    @request.query_parameters = ''
    
    post :wheel
        
    assert_header 'X-GeoChat-Action', 'reply'
  end
  
  test "should return appropiate GeoChat responde headers" do
    @request.env['RAW_POST_DATA'] = '123'
    
    wheel_combination = mock()
    WheelCombination.expects(:new).returns(wheel_combination)
    wheel_combination.expects(:record!)
    wheel_combination.expects(:message).returns('Wheel Decoded Message')
    wheel_combination.expects(:digits).returns(['123'])
    
    post :wheel
    
    assert_header('X-GeoChat-Action', 'reply-and-continue')
    assert_header('X-GeoChat-ReplaceWith', 'Wheel Decoded Message')
  end
  
  test "should decode a message with a plain code" do
    @request.env['RAW_POST_DATA'] = '123456789'
    
    wheel_combination = mock()
    WheelCombination.expects(:new).with(anything, '123456789', anything).returns(wheel_combination)
    wheel_combination.expects(:record!)
    wheel_combination.expects(:message).returns('Key1: Value1, Key2: Value2, Key3: Value3')
    wheel_combination.expects(:digits).returns(['123456789'])
    
    post :wheel
    
    assert_header('X-GeoChat-ReplaceWith', 'Key1: Value1, Key2: Value2, Key3: Value3')
  end
  
  test "should return success message with number of understanded codes" do
    wheel_combination = mock()
    WheelCombination.expects(:new).returns(wheel_combination)
    wheel_combination.stubs(:record!)
    wheel_combination.stubs(:message)
    wheel_combination.expects(:digits).returns(['123','456','789'])
    
    post :wheel
    
    assert_equal((I18n.t :wheel_success_message, :reports => '3'), assigns(:message))
  end
  
  def assert_header(header, value)
    assert_equal @response.headers[header], value
  end
  
end
