class Wheel < ActiveRecord::Base
  
  @@max_field_code = 999
  
  has_many :wheel_rows, :dependent => :destroy
  
  validates_presence_of :name, :factor0, :factor1, :factor2
  validates_inclusion_of :factor0, :factor1, :factor2, :in => Prime.primes
  validates_length_of :wheel_rows, :is => 3
  # validate uniquess of f0 f1 f2
  
  accepts_nested_attributes_for :wheel_rows
  
  alias :rows :wheel_rows
  
  before_validation_on_create :calculate_factors
  
  def self.find_for_factors(factors)
    Wheel.find :first, :conditions => {:factor0 => factors[0], :factor1 => factors[1], :factor2 => factors[2]}
  end

  private

  def calculate_factors
    rows_count = rows.map{|r| r.values.length}
    factors = rows_count.map{|c| get_best_factor(c)}
    
    # TODO improve this
    while true do
      count = Wheel.count :all, :conditions => {:factor0 => factors[0], :factor1 => factors[1], :factor2 => factors[2]}
      break if count == 0
      maxFactor = factors.max
      factors[factors.index maxFactor] = Prime.find_first_smaller_than maxFactor
    end
    
    self.factor0 = factors[0]
    self.factor1 = factors[1]
    self.factor2 = factors[2]
    
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
