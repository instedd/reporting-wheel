require 'test_helper'

class WheelCombinationTest < ActiveSupport::TestCase

  test "should fail if the body has no wheel code" do
    assert_decode_fails 'foo', 'No wheel code present in the message'
  end
  
  test "should fail if wheel code length is not multiple of 3" do
    assert_decode_fails '12345', 'No wheel code present in the message'
  end
  
  test "should fail if wheel is not found" do
    assert_decode_fails '123456789', 'Wheel not found'
  end
  
  test "should succeed with appropiate values" do
    setup_valid_request
    
    wheel_combination = WheelCombination.new @wheel_code, {}
    wheel_combination.record!
    
    assert_equal 'Label1:Value1,Label2:Value2,Label3:Value3', wheel_combination.message 
  end
  
  test "should decode inline codes" do
    setup_valid_request
    
    wheel_combination = WheelCombination.new(@wheel_code + ",Label4:Value4,Label5:Value5")
    wheel_combination.record!
    
    assert_equal 'Label1:Value1,Label2:Value2,Label3:Value3,Label4:Value4,Label5:Value5', wheel_combination.message
  end
  
  test "should enqueue a decode callback job" do
    setup_valid_request
    
    wheel_combination = WheelCombination.new @wheel_code, {'foo' => 'bar'}
    wheel_combination.record!
    
    jobs = Delayed::Job.all
    assert_equal 1, jobs.length
    
    job = jobs[0]
    job = YAML::load job.handler
    assert_equal 'DecodeCallbackJob', job.class.to_s
    assert_equal 'http://www.domain.com/some/url', job.url
    assert_equal 'Label1:Value1,Label2:Value2,Label3:Value3', job.body
    assert_equal ({'foo' => 'bar'}), job.query_parameters
  end
  
  private
  
  def setup_valid_request
    @wheel_code = '019019019'
        
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
    
    value1.stubs(:row).returns(row1)
    row1.stubs(:label).returns('Label1')    
    value1.stubs(:value).returns('Value1')
    
    value2.stubs(:row).returns(row2)
    row2.stubs(:label).returns('Label2')
    value2.stubs(:value).returns('Value2')
        
    value3.stubs(:row).returns(row3)
    row3.stubs(:label).returns('Label3')
    value3.stubs(:value).returns('Value3')
    
    wheel.expects(:has_callback?).returns(true)
    wheel.expects(:url_callback).returns('http://www.domain.com/some/url')
  end
  
  def assert_decode_fails(wheel_code, expected_error_message)
    exception = assert_raise RuntimeError do
      wheel_combination = WheelCombination.new wheel_code, {}
    end
    
    assert_equal expected_error_message, exception.message
  end


end