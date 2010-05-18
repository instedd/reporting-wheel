require 'test_helper'
require 'YAML'

class DecodeControllerTest < ActionController::TestCase
  
  test "should fail if wheel code is not a number" do
    setup_wheel_code 'foo'
    
    post :wheel
    
    assert_response :error
    assert_equal @response.body, "Only number are allowed"
  end
  
  test "should fail if wheel code length is not multiple of 3" do
    setup_wheel_code '12345'
    
    post :wheel
    
    assert_response :error
    assert_equal @response.body, 'The number of digist must be a multiple of 3'
  end
  
  test "should fail if wheel is not found" do
    setup_wheel_code '123456789'
    
    Wheel.stubs(:find).returns(nil)
    
    post :wheel
    
    assert_response :error
    assert_equal @response.body, 'Wheel not found'
  end
  
  test "should succeed with appropiate values" do
    setup_valid_request
        
    post :wheel
    
    assert_response :success
    assert_equal @response.body, 'Label1:Value1,Label2:Value2,Label3:Value3'
  end
  
  test "should return appropiate GeoChat responde headers" do
    setup_valid_request
    
    post :wheel
    
    assert_header('X-GeoChat-Action', 'continue')
    assert_header('X-GeoChat-Replace', 'true')
  end
  
  test "should enqueue a decode callback job" do
    setup_valid_request
    
    post :wheel
    
    jobs = Delayed::Job.all
    assert_equal 1, jobs.length
    
    job = jobs[0]
    job = YAML::load job.handler
    assert_equal 'DecodeCallbackJob', job.class.to_s
    assert_equal 'http://www.domain.com/some/url', job.url
    assert_equal 'Label1:Value1,Label2:Value2,Label3:Value3', job.body
    assert_equal @request.query_parameters, job.query_parameters
  end
  
  test "should return a GeoChat action reply header in case of an error" do
    setup_wheel_code 'invalid request'
    
    post :wheel
    
    assert_header 'X-GeoChat-Action', 'reply'
  end
  
  private
  
  def setup_wheel_code(code)
    @request.env['RAW_POST_DATA'] = code
  end
  
  def setup_valid_request
    # TODO find a way to inject query parameters
    wheel_code = '019019019'
  
    setup_wheel_code wheel_code
      
    wheel = mock()
    value1 = mock()
    row1 = mock()
    value2 = mock()
    row2 = mock()
    value3 = mock()
    row3 = mock()
    
    Wheel.expects(:find_for_factors).with([19,19,19]).returns(wheel)
    
    WheelValue.expects(:find_for).with(wheel,0,19).returns(value1)
    WheelValue.expects(:find_for).with(wheel,1,19).returns(value2)
    WheelValue.expects(:find_for).with(wheel,2,19).returns(value3)
    
    WheelRecord.expects(:create!).returns(nil)
    
    value1.expects(:row).returns(row1)
    row1.expects(:label).returns('Label1')    
    value1.expects(:value).returns('Value1')
    
    value2.expects(:row).returns(row2)
    row2.expects(:label).returns('Label2')
    value2.expects(:value).returns('Value2')
        
    value3.expects(:row).returns(row3)
    row3.expects(:label).returns('Label3')
    value3.expects(:value).returns('Value3')
    
    wheel.expects(:has_callback?).returns(true)
    wheel.expects(:url_callback).returns('http://www.domain.com/some/url')
  end
  
  def assert_header(header, value)
    assert_equal @response.headers[header], value
  end
  
end