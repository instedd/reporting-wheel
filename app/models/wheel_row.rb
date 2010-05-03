class WheelRow < ActiveRecord::Base
  
  belongs_to :wheel
  has_many :wheel_values, :dependent => :destroy
  
  validates_presence_of :index, :label
  validates_length_of :wheel_values, :minimum => 1
  
  accepts_nested_attributes_for :wheel_values, :reject_if => lambda{|wv| wv[:value].blank? }, :allow_destroy => true
  
  alias :values :wheel_values
  
end
