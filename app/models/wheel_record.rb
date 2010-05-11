require 'YAML'

class WheelRecord < ActiveRecord::Base
  
  belongs_to :wheel
  
  validates_presence_of :wheel, :code, :data
  
  def data_value
    YAML.load(data)
  end
  
end
