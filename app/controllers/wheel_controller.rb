require 'rvg/rvg'
include Magick

class WheelController < ApplicationController
  
  @@angle_separation = 7
  
  def new
    @wheel = Wheel.new
    3.times do |i|
      row = @wheel.rows.build
      row.index = i
    end
  end
  
  def create
    @wheel = Wheel.new(params[:wheel])
    
    if @wheel.save
      flash[:notice] = "Wheel Successfully created"
      redirect_to :action => 'show'
    else
      render :action => 'new'
    end
  end
  
  def draw
    radius = 250
    names = ['Malaria', 'HIV', 'Colera', 'Sarasa', 'Papap']
    values = ['001','002','003', '004', '005']
    indexes = (0..names.count-1).map{|i| i - names.count/2}.reverse
    
    RVG::dpi = 72
    
    rvg = RVG.new(1000, 1000).viewbox(0,0,1000,1000) do |canvas|
       canvas.background_fill = 'white'
       canvas.g.translate(500,500) do |group|
         group.circle(radius).styles(:fill => '#94B487', :stroke => 'black')
         names.each_with_index do |name, i|
          angle = @@angle_separation * indexes[i]
          angle_rad = to_rad angle
          dx = (radius - 10) * Math.cos(angle_rad)
          dy = (radius - 10) * Math.sin(angle_rad)
          group.text(dx*-1, dy*-1, name).rotate(angle).styles(:text_anchor =>'start', :font_size => 18,
            :font_family => 'monaco', :fill => 'black')
          group.text(dx, dy, values[i]).rotate(angle).styles(:text_anchor => 'end', :font_size => 18, 
            :font_family => 'helvetica', :fill => 'black')                                                       
         end
       end
     end
     
     img = rvg.draw
     img.format = "PNG"

     send_data(img.to_blob, :disposition => 'inline', :type => 'image/png')
  end
  
  private
  
  def to_rad(angle)
    angle * Math::PI / 180.0
  end
  
end
