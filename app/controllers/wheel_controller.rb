require 'rvg/rvg'
require 'pdf/writer'
include Magick

RVG::dpi = 144

class WheelController < ApplicationController
  
  @@angle_separation = 4          # (initial) angle separation for values/codes 
  @@angle_modifier = 2            # angle modifier (angle of row n will be "initial angle separation + n * angle modifier")
  @@initial_radius = 10.5.cm      # radius of outer circle (row 0)
  @@row_separation = 0.1.cm       # separation from text to the next wheel border
  @@values_font_size = 14         # font size for values
  @@codes_font_size = 22          # font size for codes
  @@left_size = 2.cm            # size for text on the left side (values)
  
  @@left_size_field_1 = 4.cm            # size for text on the left side (values)
  @@left_size_field_2 = 1.cm            # size for text on the left side (values)
  @@left_size_field_3 = 1.cm            # size for text on the left side (values)
 
  @@right_size = 1.cm             # size for text on the right side (codes)
  @@field_cover_height = 0.8.cm   # box height
  @@width = 22.cm                 # width of image
  @@height = 22.cm                # height of image
  @@outer_margin = 0.5.cm         # separation from wheel border to text for row 0
  @@inner_margin = 0.2.cm         # separation from wheel border to text for row i (i > 0)
  @@stroke_width = 3              # width of borders
  
  before_filter :find_wheel, :only => [:draw_text, :draw, :edit, :update, :delete]
  
  def index
    @wheels = Wheel.all
  end
  
  def new
    @wheel = Wheel.new
    @wheel.ok_text = "Your report of {Quantity} {Type} of {Disease} was received. Thank you!"
    
    defaults = [['Disease', 'Malaria', 'Flu', 'Cholera'], ['Quantity', '1', '2', '3'], ['Type', 'Cases', 'Deaths']]
    defaults.each do |values| 
      row = @wheel.rows.build
      row.label = values[0] 
      values[1 .. -1].each do |value|
        row_value = row.values.build
        row_value.value = value
      end
    end
  end
  
  def create
    @wheel = Wheel.new(params[:wheel])
    
    if @wheel.save
      flash[:notice] = "Wheel \"#{@wheel.name}\" created"
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end
  
  def edit
  end
  
  def update
    if @wheel.update_attributes(params[:wheel])
      flash[:notice] = "Wheel \"#{@wheel.name}\" udpated"
      redirect_to :action => 'index'
    else
      render :action => 'edit'
    end
  end
  
  def delete
    @wheel.destroy
    flash[:notice] = "Wheel \"#{@wheel.name}\" deleted"
    redirect_to :action => 'index'
  end
  
  def draw
    pdf = PDF::Writer.new
    
    # Draw wheel rows
    @wheel.rows.sort.each_with_index do |row, i|
    
      case i 
        when 0 
          row_left_offset = 0 
        when 1
          row_left_offset = @@left_size_field_1
        when 2
          row_left_offset = @@left_size_field_1 + @@left_size_field_2
        else
          row_left_offset = @@left_size_field_1 + @@left_size_field_2 + @@left_size_field_3 + (i - 3) * @@left_size
      end
    
      rvg = RVG.new(@@width, @@height) do |canvas|
        canvas.background_fill = 'white'
    
        canvas.g.translate(@@initial_radius + 0.1.cm, @@initial_radius + 0.1.cm) do |group| 
          left_radius = @@initial_radius - row_left_offset - i * @@row_separation - ( i > 0 ? @@outer_margin : 0) - (i > 1 ? (i-1) * @@inner_margin : 0)
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
             :font_family => font_family, :fill => 'black')

            dx = (right_radius - margin) * Math.cos(angle_rad)
            dy = (right_radius - margin) * Math.sin(angle_rad)
            
            #group.text(dx, dy, value.code).rotate(angle).styles(:text_anchor => 'end', :font_size => @@codes_font_size, 
            # :font_family => 'helvetica', :fill => 'black')
            
            #Force codes to have 3 digits (pad with leading zeros)
            group.text(dx, dy, "%03d" % value.code).rotate(angle).styles(:text_anchor => 'end', :font_size => @@codes_font_size, 
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
    if @wheel.cover_image_path
      pdf.add_image_from_file(@wheel.absolute_cover_image_path, 0 ,0, @@width * 0.5, @@height * 0.5)
    else
      draw_blank_cover_on pdf
    end
    
    send_data(pdf.render , :disposition => 'inline', :type => 'application/pdf', :filename => "wheel_#{@wheel.name}.pdf")
  end
  
  def draw_blank_cover
    img_cover = blank_cover_image params[:rows_count].to_i, 'PNG'
    send_data(img_cover.to_blob, :disposition => 'inline', :type => 'application/png', :filename => 'wheel_blank_cover.png')
  end
  
  private
  
  def font_family
    if RUBY_PLATFORM.include? "linux"
      "Garuda"
    else
      "Kh Battambang"
    end
  end
  
  def draw_blank_cover_on(pdf)
    # Draw wheel cover
    img_cover = blank_cover_image(@wheel.rows.length, 'JPG')
    pdf.add_image(img_cover.to_blob {self.quality = 100}, 0 ,0, img_cover.columns * 0.5, img_cover.rows * 0.5)
  end
  
  def blank_cover_image(rows_count, format)
    rvg_cover = RVG.new(@@width, @@height) do |canvas|
      canvas.background_fill = 'white'
      
      canvas.g.translate(@@initial_radius + 0.1.cm, @@initial_radius + 0.1.cm) do |g|
        
        g.circle(0.1.cm).styles(:fill => 'black')
    
        g.circle(@@initial_radius).styles(:fill => 'transparent', :stroke => 'black', :stroke_width => @@stroke_width)
        
        # draw left boxes (boxes for values)
        rows_count.times do |i|
          dx = - @@initial_radius + i * @@left_size + i * @@row_separation + i * @@inner_margin + @@outer_margin
          dy = - @@field_cover_height / 2 - 0.1.cm
          g.rect(@@left_size, @@field_cover_height, dx, dy).styles(:fill => 'transparent', :stroke => 'black', :stroke_width => @@stroke_width)
        end
        
        # draw right box (box for code)
        width = rows_count * @@right_size + (rows_count - 1) * (@@row_separation + @@inner_margin)
        height = @@field_cover_height
        dx = @@initial_radius - width - @@outer_margin
        dy = - @@field_cover_height / 2 - 0.1.cm
        
        g.rect(width, height, dx, dy).styles(:fill => 'transparent', :stroke => 'black', :stroke_width => @@stroke_width)
      end
    end
    
    img_cover = rvg_cover.draw
    img_cover.format = format
    img_cover
  end
  
  def circle(container, left_radius, right_radius)
    container.path("M -#{left_radius},0 A#{left_radius},#{left_radius} 0 0,0 #{left_radius},0 L -#{left_radius},0").rotate(90).styles(:fill => '#94B487', :stroke => 'black', :stroke_width => @@stroke_width)
    container.path("M -#{right_radius},0 A#{right_radius},#{right_radius} 0 0,0 #{right_radius},0 L -#{right_radius},0").rotate(-90).styles(:fill => '#94B487', :stroke => 'black', :stroke_width => @@stroke_width)
    container
  end
  
  def to_rad(angle)
    angle * Math::PI / 180.0
  end
  
  def find_wheel
    @wheel = Wheel.find_by_id params[:id], :include => {:wheel_rows => :wheel_values}
    redirect_to :action => :index if not @wheel
  end
  
end
