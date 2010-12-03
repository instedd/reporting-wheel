require 'guid'

class User < ActiveRecord::Base
  acts_as_authentic
  
  has_many :wheels
  
  before_create :generate_submit_url_key
  
  private
  
  def generate_submit_url_key
    self.submit_url_key = Guid.new.to_s
  end
end