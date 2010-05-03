class DecodeController < ApplicationController
  
  def wheel
    wheel_id = params[:id]
    
    codes = [wheel_id[0..2], wheel_id[3..5], wheel_id[6..8]]
    factors = codes.map{|c| Prime.factorize c.to_i}
    wheel = Wheel.find_for_factors factors
    
    # TODO define map_with_index !
    values = []
    codes.each_with_index{|c,i| values << WheelValue.find_for(wheel, i, c)}
    
    render :json => values.map{|v| v.value}.to_json
  end
  
end