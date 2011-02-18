require 'test_helper'
require 'yaml'

class DecodeControllerTest < ActionController::TestCase
  
  test "should return error message in Thai" do
    @request.env['RAW_POST_DATA'] = 'foo'
    post(:wheel, :locale => 'th')
    
    assert_equal((I18n.t :wheel_error_message, :code => 'foo', :locale => 'th'), assigns(:message))
  end
  
  test "should return success message in Thai" do
    wheel_combination = mock()
    WheelCombination.expects(:new).returns(wheel_combination)
    wheel_combination.expects(:record!)
    wheel_combination.expects(:message).returns('Wheel Decoded Message')
    
    post :wheel, :locale => 'th'
    
    assert_equal((I18n.t :wheel_success_message, :locale => 'th'), assigns(:message))
  end
  
  test "should return a GeoChat action reply header in case of an error" do
    @request.env['RAW_POST_DATA'] = 'foo'
    @request.query_parameters = ''
    
    post :wheel
        
    assert_header 'X-GeoChat-Action', 'reply'
  end
  
  test "should return successful message when understood" do
    wheel_combination = mock()
    WheelCombination.expects(:new).returns(wheel_combination)
    wheel_combination.expects(:record!)
    wheel_combination.expects(:message).returns('Wheel Decoded Message')
    
    post :wheel
    
    assert_equal I18n.t(:wheel_success_message), assigns(:message)
  end
  
  test "should return appropiate GeoChat responde headers" do
    @request.env['RAW_POST_DATA'] = '123'
    
    wheel_combination = mock()
    WheelCombination.expects(:new).returns(wheel_combination)
    wheel_combination.expects(:record!)
    wheel_combination.expects(:message).returns('Wheel Decoded Message')
    
    post :wheel
    
    assert_header('X-GeoChat-Action', 'reply-and-continue')
    assert_header('X-GeoChat-Replace', 'true')
    assert_header('X-GeoChat-ReplaceWith', 'Wheel Decoded Message')
  end
  
  test "should decode a message with a plain code" do
    @request.env['RAW_POST_DATA'] = '123456789'
    
    wheel_combination = mock()
    WheelCombination.expects(:new).with(anything, '123456789', anything).returns(wheel_combination)
    wheel_combination.expects(:record!)
    wheel_combination.expects(:message).returns('Key1: Value1, Key2: Value2, Key3: Value3')
    
    post :wheel
    
    assert_header('X-GeoChat-ReplaceWith', 'Key1: Value1, Key2: Value2, Key3: Value3')
  end
  
  def assert_header(header, value)
    assert_equal @response.headers[header], value
  end
  
end
