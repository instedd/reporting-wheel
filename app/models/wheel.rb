class Wheel < ActiveRecord::Base
  
  @@max_field_code = 999
  
  has_many :wheel_rows, :dependent => :destroy
  
  validates_presence_of :name
  validates_length_of :wheel_rows, :minimum => 1
  
  accepts_nested_attributes_for :wheel_rows, :allow_destroy => true
  
  alias :rows :wheel_rows
  
  before_validation_on_create :calculate_factors
  before_validation_on_update :calculate_factors
  
  def self.find_for_factors(factors)
    Wheel.find :first, :conditions => {:factors => factors.join(',')}
  end
  
  def self.exists_for_factors(factors)
    count = Wheel.count :all, :conditions => {:factors => factors.join(',')}
    count > 0
  end
  
  private
  
  def validate
    # validate uniqueness of factors
    # validate inclusion of factors in Prime.primes
    # validate length of factors == length of rows
    fs = self.factors.split(',')
  end

  def calculate_factors
    rows_count = rows.map{|r| r.values.length}
    
    # check that there isnt a row with no values, otherwise we will divide by 0
    return if rows_count.min == 0
    
    factors = rows_count.map{|c| get_best_factor(c)}
    
    # TODO improve this
    while true do
      exists = Wheel.exists_for_factors factors
      break if not exists
      maxFactor = factors.max
      factors[factors.index maxFactor] = Prime.find_first_smaller_than maxFactor
    end
    
    self.factors = factors.join(',')
    
    rows.each_with_index do |row, row_index|
      row.index = row_index
      row.values.each_with_index do |value, value_index|
        value.index = value_index
        value.code = factors[row_index] * Prime.value_for(value_index)
      end
    end
  end
  
  def get_best_factor(count)
    ceiling = @@max_field_code / (Prime.value_for(count-1))
    Prime.find_first_smaller_than ceiling
  end
  
end
