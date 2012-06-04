require 'array'

class TwilioController < ApplicationController
  before_filter :set_locale
  
  protect_from_forgery :except => [:hello, :receive_code]
  
  def hello
    @hello_response = request.protocol + request.host + VoiceChannel.hello_response 
    render :content_type => 'application/xml'
  end
  
  def receive_code
    begin
      @error = false
      
      digits = params[:Digits];
      metadata = request.query_parameters
  
      wheel_combination = WheelCombination.new digits, metadata
      wheel_combination.record!
      
      @success_message = request.protocol + request.host + wheel_combination.wheel.success_voice_path
    rescue RuntimeError => e
      @error = true
      @error_message = request.protocol + request.host + VoiceChannel.failure_response    
    end
    
    render :content_type => 'application/xml'
  end
  
  private
  
  def set_locale
    load_voice_channel
    I18n.locale = @voice_channel.language
  end
  
  def load_voice_channel
    called_from = params[:Called]
    @voice_channel = VoiceChannel.where(:number => called_from).first
  end
end