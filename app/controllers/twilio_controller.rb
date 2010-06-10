
class TwilioController < ApplicationController
  
  def hello
    render :content_type => 'application/xml'
  end
  
end