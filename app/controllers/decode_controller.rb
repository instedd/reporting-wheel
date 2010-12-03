require 'array'

class DecodeController < ApplicationController
  
  protect_from_forgery :except => :wheel
  
  def wheel
    begin
      body = request.raw_post
      metadata = request.query_parameters
      
      user = User.find_by_submit_url_key params[:key]
      
      comb = WheelCombination.new user, body, metadata
      comb.record!
      
      # Add GeoChat response headers
      response.headers['X-GeoChat-Action'] = 'continue'
      response.headers['X-GeoChat-Replace'] = 'true'
      
      @message = comb.message
    rescue RuntimeError => e
      response.headers['X-GeoChat-Action'] = 'reply'
      @message = I18n.t :wheel_error_message, :code => body
    end
    
    render :text => @message
  end
  
  def test
    render :text => WheelCombination.new(params[:digits]).message
  rescue RuntimeError => e
    render :text => 'Report code not understood'
  end
end
