require 'test_helper'

class WheelCombinationTest < ActiveSupport::TestCase
  
  def setup
    @pool = Pool.make
    @wheel = Wheel.make :pool => @pool
    @code = @wheel.rows.inject(""){|s,r| s + r.values.first.code.to_s}
  end

  test "should fail if the body has no wheel code" do
    assert_decode_fails @pool, 'foo', 'No wheel code present in the message'
  end
  
  test "should fail if wheel code length is not multiple of 3" do
    assert_decode_fails @pool, '12345', 'No wheel code present in the message'
  end
  
  test "should fail if wheel is not found" do
    assert_decode_fails @pool, '123456789', 'Wheel not found'
  end
  
  test "should succeed with appropiate values" do
    code, values = code_and_values(@wheel)
    
    wheel_combination = WheelCombination.new @pool, code
    wheel_combination.record!
    
    assert_equal values, wheel_combination.message 
  end
  
  test "should decode inline codes" do
    code, values = code_and_values(@wheel)
    
    wheel_combination = WheelCombination.new @pool, "#{code},Label4:Value4,Label5:Value5"
    wheel_combination.record!
    
    assert_equal "#{values},Label4:Value4,Label5:Value5", wheel_combination.message
  end
  
  test "should decode all codes present in the body" do
    code, values = code_and_values(@wheel)
    
    wheel_combination = WheelCombination.new @pool, "#{code} #{code}"
    wheel_combination.record!
    
    assert_equal "#{values} #{values}", wheel_combination.message
  end
  
  test "should enqueue a decode callback job" do
    wheel = Wheel.make :pool => @pool, :url_callback => "http://www.domain.com/some/url"
    code, values = code_and_values(wheel)
    
    wheel_combination = WheelCombination.new @pool, code, {'foo' => 'bar'}
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
    
    wheel_combination = WheelCombination.new @pool, "123123123 #{code}"
    
    assert_equal @wheel, wheel_combination.wheel
    assert_equal "123123123 #{values}", wheel_combination.message
  end
  
  test "should extract codes from the message" do
    code1, values1 = code_and_values(@wheel)
    code2, values2 = code_and_values(@wheel)
    code3, values3 = code_and_values(@wheel)
    
    wheel_combination = WheelCombination.new @pool, "#{code1} #{code2} #{code3}"
    
    assert_equal [code1, code2, code3], wheel_combination.digits
  end
  
  private
  
  def assert_decode_fails(pool, wheel_code, expected_error_message)
    exception = assert_raise RuntimeError do
      wheel_combination = WheelCombination.new pool, wheel_code, {}
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