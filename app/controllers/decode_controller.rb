require 'array'

class DecodeController < ApplicationController
  
  protect_from_forgery :except => :wheel
  
  def wheel
    begin
      digits = request.raw_post
      metadata = request.query_parameters
      
      comb = WheelCombination.new digits
      comb.record! :metadata => YAML.dump(metadata)
      
      # Add GeoChat response headers
      response.headers['X-GeoChat-Action'] = 'continue'
      response.headers['X-GeoChat-Replace'] = 'true'
      
      # Add raw decoded values to metadata
      metadata = metadata.merge comb.values.inject({}){|h,e| h[e.row.label] = e.value ; h}
      
      # Create callback job and enqueue it
      if comb.wheel.has_callback?
        Delayed::Job.enqueue DecodeCallbackJob.new(comb.wheel.url_callback, comb.message, metadata)
      end
      
      message = comb.message
    rescue Exception => e
      response.headers['X-GeoChat-Action'] = 'reply'
      message = e
      code = 500
    end
    
    render :text => message, :status => code or 200
  end
  
end
