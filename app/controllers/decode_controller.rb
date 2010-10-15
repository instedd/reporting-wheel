require 'array'

class DecodeController < ApplicationController
  
  protect_from_forgery :except => :wheel
  
  def wheel
    begin
      body = request.raw_post
      metadata = request.query_parameters
      
      # this regexp captures numbers with a multiple of 3 quantity of digits
      match = /(?:[^\d]|^)((?:\d\d\d)+)(?:[^\d]|$)/.match body
      raise "No wheel code present in the message" unless match
      digits = match[1]
      
      comb = WheelCombination.new digits, metadata
      comb.record!
      
      # Add GeoChat response headers
      response.headers['X-GeoChat-Action'] = 'continue'
      response.headers['X-GeoChat-Replace'] = 'true'
      
      body[match.begin(1)..match.end(1)-1] = comb.message
      @message = body
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
