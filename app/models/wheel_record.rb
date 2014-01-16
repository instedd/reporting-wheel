require 'yaml'

class WheelRecord < ActiveRecord::Base
  belongs_to :wheel

  validates_presence_of :wheel, :original, :decoded, :code, :data

  serialize :values, Hash

  def data_value
    YAML.load(data)
  end

  def data_str
    self.data_value.map{|k,v| k.to_str + ": " + v}.join(', ')
  end

  def values_for(label)
    if self.values.present? && self.values[label].present?
      self.values[label].join(', ')
    else
      ''
    end
  end

end
