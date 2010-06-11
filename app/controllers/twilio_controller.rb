require 'array'

class TwilioController < ActionController::Base
  
  def hello
    render :content_type => 'application/xml'
  end
  
  def receive_code
    
    digits = params[:digits];
    
    codes = [Integer(digits[0] + digits[1] + digits[2]), Integer(digits[3] + digits[4] + digits[5]), Integer(digits[6] + digits[7] + digits[8])]

    factors = codes.map{|c| Prime.factorize c}
    
    # find wheel
    wheel = Wheel.find_for_factors factors
    render :content_type => 'application/xml', :action => :wheel_not_found if wheel.nil?
             
    # find values
    values = codes.map_with_index{|c,i| WheelValue.find_for(wheel, i, c)}
      
    # save wheel record
    WheelRecord.create! :wheel => wheel, :code => wheel.id, :data => 'foo'
      
    # Output human readable message
    @message = values.map{|v| v.row.label + ":" + v.value}.join(',')
      
    ## Add raw decoded values to metadata
      #metadata = metadata.merge values.inject({}){|h,e| h[e.row.label] = e.value ; h}
      
      ## Create callback job and enqueue it
      #if wheel.has_callback?
      #  Delayed::Job.enqueue DecodeCallbackJob.new(wheel.url_callback, message, metadata)
      #end  
      
    render :content_type => 'application/xml'  
  end
end