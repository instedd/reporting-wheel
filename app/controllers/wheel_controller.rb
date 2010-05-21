require 'rvg/rvg'
require 'pdf/writer'
include Magick

RVG::dpi = 144

class WheelController < ApplicationController
  
  @@angle_separation = 5          # (initial) angle separation for values/codes 
  @@angle_modifier = 2            # angle modifier (angle of row n will be "initial angle separation + n * angle modifier")
  @@initial_radius = 10.5.cm      # radius of outer circle (row 0)
  @@row_separation = 0.1.cm       # separation from text to the next wheel border
  @@values_font_size = 20         # font size for values
  @@codes_font_size = 22          # font size for codes
  @@left_size = 2.5.cm            # size for text on the left side (values)
  @@right_size = 1.cm             # size for text on the right side (codes)
  @@field_cover_height = 0.8.cm   # box height
  @@width = 22.cm                 # width of image
  @@height = 22.cm                # height of image
  @@outer_margin = 0.5.cm         # separation from wheel border to text for row 0
  @@inner_margin = 0.2.cm         # separation from wheel border to text for row i (i > 0)
  
  before_filter :find_wheel, :only => [:draw, :edit, :update, :show]
  
  def index
    @wheels = Wheel.all
  end
  
  def new
    @wheel = Wheel.new
    3.times do |i|
      row = @wheel.rows.build
      row.label = "Row #{i}" 
      5.times do |j|
        value = row.values.build
        value.value = "Value #{i} #{j}"
      end
    end
  end
  
  def create
    @wheel = Wheel.new(params[:wheel])
    
    if @wheel.save
      flash[:notice] = "Wheel Successfully created"
      redirect_to :action => 'show', :id => @wheel.id
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @wheel.update_attributes(params[:wheel])
      redirect_to :action => 'show', :id => @wheel.id
    else
      render :action => 'edit'
    end
  end
  
  def show
  end
  
  def draw
    pdf = PDF::Writer.new
    
    # Draw wheel rows
    @wheel.rows.sort.each_with_index do |row, i|
      rvg = RVG.new(@@width, @@height) do |canvas|
        canvas.background_fill = 'white'
        
        canvas.g.translate(@@initial_radius + 0.1.cm, @@initial_radius + 0.1.cm) do |group| 
          left_radius = @@initial_radius - i * @@left_size - i * @@row_separation - ( i > 0 ? @@outer_margin : 0) - (i > 1 ? (i-1) * @@inner_margin : 0)
          right_radius = @@initial_radius - i * @@right_size - i * @@row_separation - ( i > 0 ? @@outer_margin : 0) - (i > 1 ? (i-1) * @@inner_margin : 0)
          
          circle(group, left_radius, right_radius)
          
          indexes = (0..row.values.count-1).map{|z| z - row.values.count/2}.reverse
           
          row.values.sort.each_with_index do |value, j|
            angle = (@@angle_separation + i * @@angle_modifier) * indexes[j]
            angle_rad = to_rad angle
            
            margin = i > 0 ? @@inner_margin : @@outer_margin

            dx = - (left_radius - margin) * Math.cos(angle_rad)
            dy = - (left_radius - margin) * Math.sin(angle_rad)
            group.text(dx, dy, value.value).rotate(angle).styles(:text_anchor =>'start', :font_size => @@values_font_size,
             :font_family => 'monaco', :fill => 'black')

            dx = (right_radius - margin) * Math.cos(angle_rad)
            dy = (right_radius - margin) * Math.sin(angle_rad)
            group.text(dx, dy, value.code).rotate(angle).styles(:text_anchor => 'end', :font_size => @@codes_font_size, 
             :font_family => 'helvetica', :fill => 'black')
          end
          
          group.circle(0.1.cm).styles(:fill => 'black')
        end
      end
            
      img = rvg.draw
      img.format = 'JPG'
      
      pdf.add_image(img.to_blob {self.quality = 100}, 0 ,0, img.columns * 0.5, img.rows * 0.5)
      pdf.start_new_page
    end
    
    # Draw wheel cover
    rvg_cover = RVG.new(@@width, @@height) do |canvas|
      canvas.background_fill = 'white'
      
      canvas.g.translate(@@initial_radius + 0.1.cm, @@initial_radius + 0.1.cm) do |g|
        
        g.circle(0.1.cm).styles(:fill => 'black')
    
        g.circle(@@initial_radius).styles(:fill => 'transparent', :stroke => 'black')
        
        # draw left boxes (boxes for values)
        @wheel.rows.each_with_index do |row, i|
          dx = - @@initial_radius + i * @@left_size + i * @@row_separation + i * @@inner_margin + @@outer_margin
          dy = - @@field_cover_height / 2 - 0.1.cm
          g.rect(@@left_size, @@field_cover_height, dx, dy).styles(:fill => 'transparent', :stroke => 'black')
        end
        
        # draw right box (box for code)
        rows_count = @wheel.rows.count
        width = rows_count * @@right_size + (rows_count - 1) * (@@row_separation + @@inner_margin)
        height = @@field_cover_height
        dx = @@initial_radius - width - @@outer_margin
        dy = - @@field_cover_height / 2 - 0.1.cm
        
        g.rect(width, height, dx, dy).styles(:fill => 'transparent', :stroke => 'black')
      end
    end
    
    img_cover = rvg_cover.draw
    img_cover.format = "JPG"
    
    pdf.add_image(img_cover.to_blob {self.quality = 100}, 0 ,0, img_cover.columns * 0.5, img_cover.rows * 0.5)
    
    send_data(pdf.render , :disposition => 'inline', :type => 'application/pdf', :filename => "wheel_#{@wheel.name}.pdf")
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
