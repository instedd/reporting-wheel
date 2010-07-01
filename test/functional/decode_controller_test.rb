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
    
    wheel_combination = mock()
    WheelCombination.expects(:new).returns(wheel_combination)
    wheel_combination.expects(:record!)
    wheel_combination.expects(:message).returns('')
    
    post :wheel
    
    assert_header('X-GeoChat-Action', 'continue')
    assert_header('X-GeoChat-Replace', 'true')
  end
  
  def assert_header(header, value)
    assert_equal @response.headers[header], value
  end
end
