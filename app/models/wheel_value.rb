class WheelValue < ActiveRecord::Base
  
  belongs_to :wheel_row
  
  validates_presence_of :value, :index, :code
  
  def self.find_for(wheel, index, code)
    WheelValue.find :first, :include => {:wheel_row => :wheel}, 
                            :conditions => ["wheels.id = ? AND wheel_rows.index = ? AND wheel_values.code = ?", 
                                            wheel.id, index, code]
  end
  
end
