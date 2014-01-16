require 'test_helper'
require 'yaml'

class WheelRecordTest < ActiveSupport::TestCase

  def setup
    wheel = Wheel.new
    @data = {"from" => "John", "to" => "Mary"}
    code = '123456789'
    values = {'label_a' => ['value_a'], 'label_b' => ['value_b_1', 'value_b_2']}

    @record = WheelRecord.new :wheel => wheel, :data => YAML.dump(@data), :code => code, :original => code, :decoded => 'decoded message', :values => values
  end

  test "should be valid with valid attributes" do
    assert @record.valid?
  end

  [:wheel, :code, :data, :original, :decoded].each do |field|
    test "should validate presence of #{field}" do
      @record.send("#{field}=", nil)
      assert !@record.valid?
    end
  end

  test "should return data value" do
    assert_equal @data, @record.data_value
  end

  test "should return data value as human readable string" do
    assert_equal 'from: John, to: Mary', @record.data_str
  end

  test "should return values for label" do
    assert_equal 'value_a', @record.values_for('label_a')
    assert_equal 'value_b_1, value_b_2', @record.values_for('label_b')
  end

end
