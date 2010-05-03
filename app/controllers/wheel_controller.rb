require 'rvg/rvg'
include Magick

class WheelController < ApplicationController
  
  @@angle_separation = 5
  @@initial_radius = 500
  
  before_filter :find_wheel, :only => [:draw]
  
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
    radius = @@initial_radius
    
    RVG::dpi = 72
    
    rvg = RVG.new(1500, 400*3) do |canvas|
       canvas.background_fill = 'white'
       
       @wheel.rows.sort.each_with_index do |row, i|
         canvas.g.translate(@@initial_radius + 20, 500) do |group|
           radius = @@initial_radius - i*130
           
           group.circle(radius).styles(:fill => '#94B487', :stroke => 'black')
           
           indexes = (0..row.values.count-1).map{|z| z - row.values.count/2}.reverse
           
           row.values.sort.each_with_index do |value, j|
             angle = (@@angle_separation + i) * indexes[j]
             angle_rad = to_rad angle
             dx = (radius - 10) * Math.cos(angle_rad)
             dy = (radius - 10) * Math.sin(angle_rad)
             group.text(dx*-1, dy*-1, value.value).rotate(angle).styles(:text_anchor =>'start', :font_size => 20,
               :font_family => 'monaco', :fill => 'black')
             group.text(dx, dy, value.code).rotate(angle).styles(:text_anchor => 'end', :font_size => 20, 
               :font_family => 'helvetica', :fill => 'black')
           end
         end
         #canvas.g.translate(500,500).rotate(-90).path("M -200,0 A200,200 0 0,0 200,0 L -200,0")
       end
       
       
       # canvas.g.translate(500,500) do |group|
       #   group.circle(radius).styles(:fill => '#94B487', :stroke => 'black')
       #   names.each_with_index do |name, i|
       #    angle = @@angle_separation * indexes[i]
       #    angle_rad = to_rad angle
       #    dx = (radius - 10) * Math.cos(angle_rad)
       #    dy = (radius - 10) * Math.sin(angle_rad)
       #    group.text(dx*-1, dy*-1, name).rotate(angle).styles(:text_anchor =>'start', :font_size => 18,
       #      :font_family => 'monaco', :fill => 'black')
       #    group.text(dx, dy, values[i]).rotate(angle).styles(:text_anchor => 'end', :font_size => 18, 
       #      :font_family => 'helvetica', :fill => 'black')                                                       
       #   end
       # end
     end
     
     img = rvg.draw
     img.format = "PNG"

     send_data(img.to_blob, :disposition => 'inline', :type => 'image/png')
  end
  
  private
  
  def to_rad(angle)
    angle * Math::PI / 180.0
  end
  
  def find_wheel
    @wheel = Wheel.find(params[:id])
  end
  
end
