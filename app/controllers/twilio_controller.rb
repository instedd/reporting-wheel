require 'array'

class TwilioController < ApplicationController
  before_filter :set_locale
  
  protect_from_forgery :except => :hello
  
  def hello
    @hello_response = request.protocol + request.host + VoiceChannel.hello_response 
    render :content_type => 'application/xml'
  end
  
  def receive_code
    
    digits = params[:Digits];
    
    codes = [digits[0..2], digits[3..5], digits[6..8]].map do |x| Integer(x) end

    codes.reverse!

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
  
  private
  
  def set_locale
    load_voice_channel
    I18n.locale = @voice_channel.language
  end
  
  def load_voice_channel
    called_from = params[:Called]
    @voice_channel = VoiceChannel.find :first, :conditions => { :number => called_from }
  end
end