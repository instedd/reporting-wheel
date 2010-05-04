require 'rvg/rvg'
include Magick

class WheelController < ApplicationController
  
  @@angle_separation = 5
  @@angle_modifier = 2
  @@initial_radius = 10.4.cm
  @@row_separation = 0.2.cm
  @@colors = ['red', 'green', 'blue']
  @@values_font_size = 14
  @@codes_font_size = 16 
  @@left_size = 2.5.cm
  @@right_size = 1.cm
  
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
    left_margin = 0
    
    RVG::dpi = 90
    
    rvg = RVG.new(21.cm,29.7.cm) do |canvas|
       canvas.background_fill = 'white'
       
       @wheel.rows.sort.each_with_index do |row, i|
         canvas.g.translate(@@initial_radius + 0.1.cm, @@initial_radius + 0.1.cm) do |group|
           left_radius = @@initial_radius - i * @@left_size - i * @@row_separation
           right_radius = @@initial_radius - i * @@right_size - i * @@row_separation
           
           circle(group, left_radius, right_radius)
           
           indexes = (0..row.values.count-1).map{|z| z - row.values.count/2}.reverse
           
           row.values.sort.each_with_index do |value, j|
             angle = (@@angle_separation + i * @@angle_modifier) * indexes[j]
             angle_rad = to_rad angle
             
             dx = - (left_radius - @@row_separation) * Math.cos(angle_rad)
             dy = - (left_radius - @@row_separation) * Math.sin(angle_rad)
             group.text(dx, dy, value.value).rotate(angle).styles(:text_anchor =>'start', :font_size => @@values_font_size,
               :font_family => 'monaco', :fill => 'black')
             
             dx = (right_radius - @@row_separation) * Math.cos(angle_rad)
             dy = (right_radius - @@row_separation) * Math.sin(angle_rad)
             group.text(dx, dy, value.code).rotate(angle).styles(:text_anchor => 'end', :font_size => @@codes_font_size, 
               :font_family => 'helvetica', :fill => 'black')
           end
           
           # max_value = row.values.map{|v| v.value.length}.max
           # left_margin += max_value * @@ppc
         end
       end
     end
     
     img = rvg.draw
     img.format = "PNG"

     send_data(img.to_blob, :disposition => 'inline', :type => 'image/png')
  end
  
  private
  
  def circle(container, left_radius, right_radius)
    container.path("M -#{left_radius},0 A#{left_radius},#{left_radius} 0 0,0 #{left_radius},0 L -#{left_radius},0").rotate(90).styles(:fill => '#94B487', :stroke => 'black')
    container.path("M -#{right_radius},0 A#{right_radius},#{right_radius} 0 0,0 #{right_radius},0 L -#{right_radius},0").rotate(-90).styles(:fill => '#94B487', :stroke => 'black')
    container
  end
  
  def to_rad(angle)
    angle * Math::PI / 180.0
  end
  
  def find_wheel
    @wheel = Wheel.find(params[:id])
  end
  
end
