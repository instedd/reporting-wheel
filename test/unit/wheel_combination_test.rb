require 'test_helper'

class WheelCombinationTest < ActiveSupport::TestCase
  
  def setup
    @user = User.make
    @wheel = Wheel.make :user => @user
    @code = @wheel.rows.inject(""){|s,r| s + r.values.first.code.to_s}
  end

  test "should fail if the body has no wheel code" do
    assert_decode_fails @user, 'foo', 'No wheel code present in the message'
  end
  
  test "should fail if wheel code length is not multiple of 3" do
    assert_decode_fails @user, '12345', 'No wheel code present in the message'
  end
  
  test "should fail if wheel is not found" do
    assert_decode_fails @user, '123456789', 'Wheel not found'
  end
  
  test "should succeed with appropiate values" do
    code, values = code_and_values(@wheel)
    
    wheel_combination = WheelCombination.new @user, code
    wheel_combination.record!
    
    assert_equal values, wheel_combination.message 
  end
  
  test "should decode inline codes" do
    code, values = code_and_values(@wheel)
    
    wheel_combination = WheelCombination.new @user, "#{code},Label4:Value4,Label5:Value5"
    wheel_combination.record!
    
    assert_equal "#{values},Label4:Value4,Label5:Value5", wheel_combination.message
  end
  
  test "should decode all codes present in the body" do
    code, values = code_and_values(@wheel)
    
    wheel_combination = WheelCombination.new @user, "#{code} #{code}"
    wheel_combination.record!
    
    assert_equal "#{values} #{values}", wheel_combination.message
  end
  
  test "should enqueue a decode callback job" do
    wheel = Wheel.make :user => @user, :url_callback => "http://www.domain.com/some/url"
    code, values = code_and_values(wheel)
    
    wheel_combination = WheelCombination.new @user, code, {'foo' => 'bar'}
    wheel_combination.record!
    
    jobs = Delayed::Job.all
    assert_equal 1, jobs.length
    
    job = jobs[0]
    job = YAML::load job.handler
    assert_equal 'DecodeCallbackJob', job.class.to_s
    assert_equal 'http://www.domain.com/some/url', job.url
    assert_equal values, job.body
    assert_equal ({'foo' => 'bar'}), job.query_parameters
  end
  
  test "should look for the code in the entire message" do
    code, values = code_and_values(@wheel)
    
    wheel_combination = WheelCombination.new @user, "123 #{code}"
    
    assert_equal @wheel, wheel_combination.wheel
    assert_equal "123 #{values}", wheel_combination.message
  end
  
  private
  
  def assert_decode_fails(user, wheel_code, expected_error_message)
    exception = assert_raise RuntimeError do
      wheel_combination = WheelCombination.new user, wheel_code, {}
    end
    
    assert_equal expected_error_message, exception.message
  end
  
  def code_and_values(wheel)
    codes = []
    values = []
    wheel.rows.sort.each do |row|
      index = rand(row.values.length)
      value = row.values[index]
      codes << value.code
      values << row.label + ":" + value.value
    end
    
    [codes.reverse.join,values.join(', ')]
  end


end