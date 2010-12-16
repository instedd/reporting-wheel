class Pool < ActiveRecord::Base
  has_many :wheels
  
  validates_presence_of :name
end