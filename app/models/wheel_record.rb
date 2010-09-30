require 'yaml'

class WheelRecord < ActiveRecord::Base
  
  belongs_to :wheel
  
  validates_presence_of :wheel, :code, :data
  
  def data_value
    YAML.load(data)
  end
  
  def data_str
    self.data_value.map{|k,v| k.to_str + ": " + v}.join(', ')
  end
  
end
