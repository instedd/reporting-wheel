class WheelValue < ActiveRecord::Base
  
  belongs_to :wheel_row
  
  validates_presence_of :value, :index, :code
  
end
