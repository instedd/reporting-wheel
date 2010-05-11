require 'test_helper'
require 'YAML'

class WheelRecordTest < ActiveSupport::TestCase
  
  def setup
    wheel = Wheel.new
    @data = {:from => 'John', :to => 'Mary'}
    code = '123456789'
    
    @record = WheelRecord.new :wheel => wheel, :data => YAML.dump(@data), :code => code
  end
  
  test "should be valid with valid attributes" do
    assert @record.valid?
  end
  
  [:wheel, :code, :data].each do |field|
    test "should validate presence of #{field}" do
      @record.send("#{field}=", nil)
      assert !@record.valid?
    end
  end
  
  test "should return data value" do
    assert_equal @data, @record.data_value
  end
  
end
