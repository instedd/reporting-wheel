require 'array'

class DecodeController < ApplicationController
  
  protect_from_forgery :except => :wheel
  
  def wheel
    begin
      digits = request.raw_post
      metadata = request.query_parameters
      
      comb = WheelCombination.new digits, metadata
      comb.record!
      
      # Add GeoChat response headers
      response.headers['X-GeoChat-Action'] = 'continue'
      response.headers['X-GeoChat-Replace'] = 'true'
      
      message = comb.message
    rescue RuntimeError => e
      response.headers['X-GeoChat-Action'] = 'reply'
      message = e
    end
    
    render :text => message
  end
  
  def test
    render :text => WheelCombination.new(params[:digits]).message
  rescue RuntimeError => e
    render :text => 'Report code not understood'
  end
end
