require 'array'

class DecodeController < ApplicationController
  
  protect_from_forgery :except => :wheel
  
  def wheel
    begin
      wheel_id = request.raw_post
      metadata = request.query_parameters
      
      raise "Only number are allowed" unless /^\d+$/.match(wheel_id)
      
      raise "The number of digist must be a multiple of 3" unless (wheel_id.length % 3) == 0
      
      # extract codes from id
      count = wheel_id.length / 3
      codes = count.times.map{|i| wheel_id[3*i..3*i+2].to_i}.reverse
      
      # factorize codes to find factors
      # TODO check if factorize fails to find factor
      factors = codes.map{|c| Prime.factorize c}
      
      # find wheel
      wheel = Wheel.find_for_factors factors
      raise 'Wheel not found' if wheel.nil?
      
      # find values
      values = codes.map_with_index{|c,i| WheelValue.find_for(wheel, i, c)}
      
      # save wheel record
      WheelRecord.create! :wheel => wheel, :code => wheel_id, :data => YAML.dump(metadata)
      
      # Output human readable message
      message = values.map{|v| v.row.label + ":" + v.value}.join(',')
      
      # Add GeoChat response headers
      response.headers['X-GeoChat-Action'] = 'continue'
      response.headers['X-GeoChat-Replace'] = 'true'
      
      # TODO Add raw decoded values to metadata
      
      # Create callback job and enqueue it
      if wheel.has_callback?
        Delayed::Job.enqueue DecodeCallbackJob.new(wheel.url_callback, message, metadata)
      end
    rescue Exception => e
      # TODO define a geochat header to indicate an error
      message = e
      code = 500
    end
    
    # debugger
    
    render :text => message, :status => code or 200
  end
  
end