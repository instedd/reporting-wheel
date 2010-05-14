require 'test_helper'

class WheelTest < ActiveSupport::TestCase
  
  def setup
    @wheel = Wheel.new :name => 'Test Wheel', :factors => [19,17,23].join(','), :url_callback => 'http://www.domain.com/a/valid/url'
    
    @row1 = @wheel.rows.build
    @row2 = @wheel.rows.build
    @row3 = @wheel.rows.build
    
    @row1.stubs(:valid?).returns(true)
    @row2.stubs(:valid?).returns(true)
    @row3.stubs(:valid?).returns(true)
    
    @wheel.stubs(:calculate_factors).returns(nil)
  end
  
  test "should be valid with valid attributes" do
    assert @wheel.save!
  end
  
  [:name, :factors].each do |field|
    test "should validate presence of #{field}" do
      @wheel.send("#{field}=", nil)
      assert !@wheel.valid?
    end
  end
  
  test "should have at least one row" do
    @wheel.wheel_rows = []
    assert !@wheel.valid?
  end
  
  test "should validate uniqueness of factors" do
    Wheel.expects(:exists_for_factors).returns(true)
    assert !@wheel.valid?
  end
  
  test "should validate that factors are primes" do
    @wheel.factors = [19,18,23].join(',')
    assert !@wheel.valid?
  end
  
  test "should validate that the number of rows is the same as the number of factors" do
    new_row = @wheel.rows.build
    new_row.stubs(:valid?).returns(true)
    
    assert !@wheel.valid?    
  end
  
  test "callback must be a valid url" do
    @wheel.url_callback = 'some invalid url'
    
    assert !@wheel.valid?
  end
  
  test "should calculate factors and update rows and values when saved" do
    wheel = Wheel.new :name => 'Save Test Wheel'
    
    row1 = wheel.rows.build
    row1.label = 'Label 1'
    value11 = row1.values.build
    value11.value = 'Value 1 1'
    value12 = row1.values.build
    value12.value = 'Value 1 2'
    
    row2 = wheel.rows.build
    row2.label = 'Label 2'
    value21 = row2.values.build
    value21.value = 'Value 2 1'
    
    row3 = wheel.rows.build
    row3.label = 'Label 3'
    value31 = row3.values.build
    value31 = 'Value 3 1'
    value32 = row3.values.build
    value32 = 'Value 3 2'
    value33 = row3.values.build
    value33 = 'Value 3 3'
    
    factors = [19,17,23]
    
    wheel.rows.each_with_index do |r,i|
      wheel.expects(:get_best_factor).with(r.values.length).returns(factors[i])
    end
    wheel.stubs(:uniqueness_of_factors).returns(nil)
    Wheel.expects(:exists_for_factors).with(factors).returns(false)
    
    wheel.save
    
    assert_equal wheel.factors, factors.join(',')
    
    wheel.rows.each_with_index do |r,i|
      assert_equal r.index, i
      r.values.each_with_index do |v,j|
        assert_equal v.index, j
        assert_equal v.code, factors[i] * Prime.value_for(j)
      end
    end
  end
  
  test "should have a callback when url_callback is defined" do
    assert @wheel.has_callback?
    @wheel.url_callback = ''
    assert !@wheel.has_callback?
    @wheel.url_callback = nil
    assert !@wheel.has_callback?
  end
  
end
