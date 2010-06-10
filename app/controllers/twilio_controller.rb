
class TwilioController < ActionController::Base
  
  def hello
    render :content_type => 'application/xml'
  end
  
end