require 'array'

class DecodeController < ApplicationController
  
  def wheel
    wheel_id = params[:id]
    count = wheel_id.length / 3 
    
    codes = count.times.map{|i| wheel_id[3*i..3*i+2]}
    
    factors = codes.map{|c| Prime.factorize c.to_i}
    wheel = Wheel.find_for_factors factors
    
    values = codes.map_with_index{|c,i| WheelValue.find_for(wheel, i, c)}
    
    render :json => values.map{|v| v.value}.to_json
  end
  
end