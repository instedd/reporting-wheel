require 'test_helper'

class WheelRowTest < ActiveSupport::TestCase
  
  def setup
    @wheel_row = WheelRow.new :label => "Disease", :index => 3
    @wheel_row.values.build
  end
  
  [:label, :index].each do |field|
    test "should validate presence of #{field}" do
      @wheel_row.send("#{field}=", nil)
      assert !@wheel_row.valid?
    end
  end
  
  test "should have at least one value" do
    @wheel_row.wheel_values = []
    assert !@wheel_row.valid?
  end
  
  test "should be ordered by its index value" do
    other_wheel_row = WheelRow.new :index => 5
    assert (@wheel_row <=> other_wheel_row) < 0
    
    other_wheel_row = WheelRow.new :index => 3
    assert (@wheel_row <=> other_wheel_row) == 0
    
    other_wheel_row = WheelRow.new :index => 1
    assert (@wheel_row <=> other_wheel_row) > 0
  end
  
end
