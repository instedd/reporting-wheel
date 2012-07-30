require 'guid'

class User < ActiveRecord::Base
  acts_as_authentic
  
  has_many :wheels
  has_many :local_gateways
  
  before_create :generate_submit_url_key
  
  private
  
  def generate_submit_url_key
    self.submit_url_key = Guid.new.to_s
  end
end