require 'test_helper'

class WheelTest < ActiveSupport::TestCase
  
  DIR_PATH = "#{RAILS_ROOT}/tmp/test"
  
  def setup
    @wheel = Wheel.new :name => 'Test Wheel', :factors => [19,17,23].join(','), :url_callback => 'http://www.domain.com/a/valid/url'
    
    @row1 = @wheel.rows.build
    @row2 = @wheel.rows.build
    @row3 = @wheel.rows.build
    
    @row1.stubs(:valid?).returns(true)
    @row2.stubs(:valid?).returns(true)
    @row3.stubs(:valid?).returns(true)
    
    @wheel.stubs(:calculate_factors).returns(nil)
    
    FileUtils.mkdir_p DIR_PATH
  end
  
  def setup_for_success_voice_file_tests
    @wheel.save!
    
    file_path = "#{RAILS_ROOT}/tmp/test/success"
    File.new(file_path, "w").close
    
    @wheel.success_voice_file = File.open(file_path, "r")
    @wheel_directory = "#{RAILS_ROOT}/public/wheels/#{@wheel.id}"
  end
  
   def setup_for_cover_image_file_tests
    @wheel.save!
    
    file_path = "#{RAILS_ROOT}/tmp/test/cover"
    File.new(file_path, "w").close
    
    @wheel.cover_image_file = File.open(file_path, "r")
    @wheel_directory = "#{RAILS_ROOT}/public/wheels/#{@wheel.id}"
  end
  
  def teardown
    @wheel.delete
    
    #cleaning up...
    FileUtils.rm_rf @wheel_directory if @wheel_directory and File.directory? @wheel_directory
    FileUtils.rm_rf DIR_PATH if File.directory? DIR_PATH  
  end
  
  test "should be valid with valid attributes" do
    assert @wheel.save
  end
  
  [:name, :factors].each do |field|
    test "should validate presence of #{field}" do
      @wheel.send("#{field}=", nil)
      assert !@wheel.valid?
    end
  end
  
  test "name should be unique" do
    @wheel.save
    
    @wheel2 = Wheel.new :name => 'Test Wheel', :factors => [19].join(','), :url_callback => 'http://www.domain.com/a/valid/url'
    row1 = @wheel2.rows.build
    row1.stubs(:valid?).returns(true)
    
    @wheel2.stubs(:calculate_factors).returns(nil)
    
    assert_false @wheel2.save
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
  
  test "should retrieve success voice path" do
    setup_for_success_voice_file_tests
    
    @wheel.save!
    
    assert_equal "/wheels/#{@wheel.id}/audio/success.mp3", @wheel.success_voice_path
  end
  
  test "should save success voice file" do
    setup_for_success_voice_file_tests
    
    @wheel.save!
    
    assert File.exists?("#{RAILS_ROOT}/public/wheels/#{@wheel.id}/audio/success.mp3")
  end
  
  test "should work if success voice file is empty" do
    @wheel.success_voice_file = ''
    @wheel.save!
  end
  
  test "should delete success voice file" do
    FileUtils.mkdir_p "#{RAILS_ROOT}/public/wheels/#{@wheel.id}/audio/"
    File.open("#{RAILS_ROOT}/public/wheels/#{@wheel.id}/audio/success.mp3", 'w') { |f| f.write 'foo' }
  
    @wheel.dont_use_success_voice_file = '1'
    @wheel.save!
    
    assert_false File.exists?("#{RAILS_ROOT}/public/wheels/#{@wheel.id}/audio/success.mp3")
  end
  
  test "should retrieve cover image path" do
    setup_for_cover_image_file_tests
    
    @wheel.save!
    
    assert_equal "/wheels/#{@wheel.id}/images/cover.jpg", @wheel.cover_image_path
  end
  
  test "should save cover image file" do
    setup_for_cover_image_file_tests
    
    @wheel.save!
    
    assert File.exists?("#{RAILS_ROOT}/public/wheels/#{@wheel.id}/images/cover.jpg")
  end
  
  test "should work if cover image file is empty" do
    @wheel.cover_image_file = ''
    @wheel.save!
  end
  
  test "should delete cover image file" do
    FileUtils.mkdir_p "#{RAILS_ROOT}/public/wheels/#{@wheel.id}/images/"
    File.open("#{RAILS_ROOT}/public/wheels/#{@wheel.id}/images/cover.jpg", 'w') { |f| f.write 'foo' }
  
    @wheel.dont_use_cover_image_file = '1'
    @wheel.save!
    
    assert_false File.exists?("#{RAILS_ROOT}/public/wheels/#{@wheel.id}/images/cover.jpg")
  end
  
  test "access render configuration" do
    w = Wheel.new
    assert_equal Wheel::DefaultRenderConfiguration.length, w.render_configuration.length
  end
  
  test "when saving keep same factors" do
    wheel = Wheel.new
    wheel.name = 'new wheel'
    defaults = [['Disease', 'Malaria', 'Flu', 'Cholera'], ['Quantity', '1', '2', '3'], ['Type', 'Cases', 'Deaths']]
    defaults.each do |values| 
      row = wheel.rows.build
      row.label = values[0] 
      values[1 .. -1].each do |value|
        row_value = row.values.build
        row_value.value = value
      end
    end
    wheel.save!
    
    old_factors = wheel.factors
    wheel.save!
    
    assert_equal old_factors, wheel.factors
    
    wheel.rows.each do |row|
      first = row.values.sort.first
      row.values.sort.each do |v|
        assert_equal first.code * (v.index + 1), v.code
      end
    end
  end
end
