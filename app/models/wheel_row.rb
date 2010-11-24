class WheelRow < ActiveRecord::Base
  
  belongs_to :wheel
  has_many :wheel_values, :dependent => :destroy
  
  validates_presence_of :index
  validates_presence_of :label, :message => "Label can't be blank"
  validates_length_of :wheel_values, :minimum => 1, :message => "At least one value is required in each of the labels"
  
  accepts_nested_attributes_for :wheel_values, :reject_if => lambda{|wv| wv[:value].blank? }, :allow_destroy => true
  
  alias :values :wheel_values
  
  def <=>(other)
    self.index <=> other.index
  end
  
end
