require 'array'

class DecodeController < ApplicationController
  
  protect_from_forgery :except => :wheel
  
  def wheel
    begin
      body = request.raw_post
      metadata = request.query_parameters
      
      # TODO this hardcodes decoding of wheels to wheels of the default pool, remove when we add pool selection 
      pool = Pool.first
      
      comb = WheelCombination.new pool, body, metadata
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
    render :text => WheelCombination.new(Pool.first, params[:digits]).message
  rescue RuntimeError => e
    render :text => 'Report code not understood'
  end
end
