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
    
    wheel_combination = WheelCombination.new("017017023,Label4:Value4,Label5:Value5")
    wheel_combination.record!
    
    assert_equal 'Label1:Value1,Label2:Value2,Label3:Value3,Label4:Value4,Label5:Value5', wheel_combination.message
  end
  
  test "should decode all codes present in the body" do
    setup_valid_request
    
    wheel_combination = WheelCombination.new("017017023 017017023")
    wheel_combination.record!
    
    assert_equal 'Label1:Value1,Label2:Value2,Label3:Value3 Label1:Value1,Label2:Value2,Label3:Value3', wheel_combination.message
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
    wheel_data = [{:code => 23, :label => 'Label1', :value => 'Value1'},
                  {:code => 17, :label => 'Label2', :value => 'Value2'},
                  {:code => 17, :label => 'Label3', :value => 'Value3'}]
    @wheel_code = '017017023'
    setup_wheel(wheel_data, 'http://www.domain.com/some/url')
  end
  
  def setup_wheel(wheel_data, callback = nil)
    wheel = mock()
    rows = wheel_data.map{|d| mock()}
    values = wheel_data.map{|d| mock()}
    codes = wheel_data.map{|d| d[:code]}
    
    Wheel.stubs(:find_for_factors).with(codes).returns(wheel)
    
    wheel_data.each_with_index do |d, index|
      WheelValue.stubs(:find_for).with(wheel,index,d[:code]).returns(values[index])
      values[index].stubs(:row).returns(rows[index])
      rows[index].stubs(:label).returns(d[:label])
      values[index].stubs(:value).returns(d[:value])
    end
    
    WheelRecord.expects(:create!).returns(nil)
    
    wheel.expects(:has_callback?).returns(!callback.nil?)
    unless callback.nil?
      wheel.expects(:url_callback).returns(callback)
    end
  end
  
  def assert_decode_fails(wheel_code, expected_error_message)
    exception = assert_raise RuntimeError do
      wheel_combination = WheelCombination.new wheel_code, {}
    end
    
    assert_equal expected_error_message, exception.message
  end


end