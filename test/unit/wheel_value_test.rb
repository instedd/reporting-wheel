require 'test_helper'

class WheelValueTest < ActiveSupport::TestCase
  
  def setup
    @wheel_value = WheelValue.new :index => 3, :value => 'Malaria', :code => 499
  end
  
  [:index, :value, :code].each do |field|
    test "should validate presence of #{field}" do
      @wheel_value.send("#{field}=", nil)
      assert !@wheel_value.valid?
    end
  end
  
  test "should validate the length of its value" do
    @wheel_value.value = "a" * 301
    assert !@wheel_value.valid?
  end
  
  test "should be ordered by its index value" do
    other_wheel_value = WheelValue.new :index => 5
    assert (@wheel_value <=> other_wheel_value) < 0
    
    other_wheel_value = WheelValue.new :index => 3
    assert (@wheel_value <=> other_wheel_value) == 0
    
    other_wheel_value = WheelValue.new :index => 1
    assert (@wheel_value <=> other_wheel_value) > 0
  end
  
  test "should find a WheelValue by its Wheel, Row Index and Code" do
    wheel = Wheel.new :name => 'Test Wheel'
    row = wheel.rows.build
    row.label = 'Test Row'
    row.values << @wheel_value
    wheel.save!
    
    recovered_wheel_value = WheelValue.find_for wheel, row.index, @wheel_value.code

    assert_equal @wheel_value, recovered_wheel_value
  end
  
end
