require 'test_helper'

class PoolTest < ActiveSupport::TestCase
  
  def setup
    @pool = Pool.new :name => "foo", :description => "bar"
  end
  
  test "should be valid with valid attributes" do
    assert @pool.valid?
  end
  
  test "should validate presence of name" do
    @pool.name = nil
    assert !@pool.valid?
  end
  
end