require 'rvg/rvg'
require 'pdf/writer'
include Magick

RVG::dpi = 144

class WheelController < ApplicationController
  
  before_filter :find_wheel, :only => [:draw_text, :draw, :edit, :update, :show, :delete]
  
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
  
  def show
  end
  
  def delete
    @wheel.destroy
    flash[:notice] = "Wheel \"#{@wheel.name}\" deleted"
    redirect_to :action => 'index'
  end
  
  def draw
    cfg = @wheel.render_configuration
  
    pdf = PDF::Writer.new
    
    # Draw wheel rows
    @wheel.rows.sort.each_with_index do |row, i|
    
      case i 
        when 0 
          row_left_offset = 0 
        when 1
          row_left_offset = cfg[:values_width_field_1].to_f
        when 2
          row_left_offset = cfg[:values_width_field_1].to_f + cfg[:values_width_field_2].to_f
        else
          row_left_offset = cfg[:values_width_field_1].to_f + cfg[:values_width_field_2].to_f + cfg[:values_width_field_3].to_f + (i - 3) * cfg[:values_width].to_f
      end
      row_left_offset = row_left_offset.cm
      
      rvg = RVG.new(cfg[:width].to_f.cm, cfg[:height].to_f.cm) do |canvas|
        canvas.background_fill = 'white'
    
        canvas.g.translate((cfg[:initial_radius].to_f + 0.1).cm, (cfg[:initial_radius].to_f + 0.1).cm) do |group| 
          left_radius = cfg[:initial_radius].to_f.cm - row_left_offset - i * cfg[:row_separation].to_f.cm - ( i > 0 ? cfg[:outer_margin].to_f.cm : 0) - (i > 1 ? (i-1) * cfg[:inner_margin].to_f.cm : 0)
          right_radius = cfg[:initial_radius].to_f.cm - i * cfg[:codes_width].to_f.cm - i * cfg[:row_separation].to_f.cm - ( i > 0 ? cfg[:outer_margin].to_f.cm : 0) - (i > 1 ? (i-1) * cfg[:inner_margin].to_f.cm : 0)
          
          circle(group, left_radius, right_radius)
          
          indexes = (0..row.values.count-1).map{|z| z - row.values.count/2}.reverse
           
          row.values.sort.each_with_index do |value, j|
            angle = (cfg[:angle_separation].to_f + i * cfg[:angle_modifier].to_f) * indexes[j]
            angle_rad = to_rad angle
            
            margin = (i > 0 ? cfg[:inner_margin] : cfg[:outer_margin]).to_f.cm

            dx = - (left_radius - margin) * Math.cos(angle_rad)
            dy = - (left_radius - margin) * Math.sin(angle_rad)
            group.text(dx, dy, value.value).rotate(angle).styles(:text_anchor =>'start', :font_size => cfg[:values_font_size].to_f,
             :font_family => cfg[:values_font_family], :fill => 'black')

            dx = (right_radius - margin) * Math.cos(angle_rad)
            dy = (right_radius - margin) * Math.sin(angle_rad)
            
            #group.text(dx, dy, value.code).rotate(angle).styles(:text_anchor => 'end', :font_size => @@codes_font_size, 
            # :font_family => 'helvetica', :fill => 'black')
            
            #Force codes to have 3 digits (pad with leading zeros)
            group.text(dx, dy, "%03d" % value.code).rotate(angle).styles(:text_anchor => 'end', :font_size => cfg[:codes_font_size].to_f, 
             :font_family => cfg[:codes_font_family], :fill => 'black')
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
      pdf.add_image_from_file(@wheel.absolute_cover_image_path, 0 ,0, cfg[:width].to_f.cm * 0.5, cfg[:height].to_f.cm * 0.5)
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
  
  def draw_blank_cover_on(pdf)
    # Draw wheel cover
    img_cover = blank_cover_image(@wheel.rows.length, 'JPG')
    pdf.add_image(img_cover.to_blob {self.quality = 100}, 0 ,0, img_cover.columns * 0.5, img_cover.rows * 0.5)
  end
  
  def blank_cover_image(rows_count, format)
    cfg = @wheel.render_configuration
  
    rvg_cover = RVG.new(cfg[:width].to_f.cm, cfg[:height].to_f.cm) do |canvas|
      canvas.background_fill = 'white'
      
      canvas.g.translate((cfg[:initial_radius].to_f + 0.1).cm, (cfg[:initial_radius].to_f + 0.1).cm) do |g|
        
        g.circle(0.1.cm).styles(:fill => 'black')
    
        g.circle(cfg[:initial_radius].to_f.cm).styles(:fill => 'transparent', :stroke => 'black', :stroke_width => cfg[:stroke_width].to_f)
        
        # draw left boxes (boxes for values)
        rows_count.times do |i|
          dx = (- cfg[:initial_radius].to_f + i * cfg[:values_width].to_f + i * cfg[:row_separation].to_f + i * cfg[:inner_margin].to_f + cfg[:outer_margin].to_f).cm
          dy = (- cfg[:field_cover_height].to_f / 2 - 0.1).cm
          g.rect(cfg[:values_width].to_f.cm, cfg[:field_cover_height].to_f.cm, dx, dy).styles(:fill => 'transparent', :stroke => 'black', :stroke_width => cfg[:stroke_width].to_f)
        end
        
        # draw right box (box for code)
        width = (rows_count * cfg[:codes_width].to_f + (rows_count - 1) * (cfg[:row_separation].to_f + cfg[:inner_margin].to_f)).cm
        height = cfg[:field_cover_height].to_f.cm
        dx = cfg[:initial_radius].to_f.cm - width - cfg[:outer_margin].to_f.cm
        dy = - cfg[:field_cover_height].to_f.cm / 2 - 0.1.cm
        
        g.rect(width, height, dx, dy).styles(:fill => 'transparent', :stroke => 'black', :stroke_width => cfg[:stroke_width].to_f)
      end
    end
    
    img_cover = rvg_cover.draw
    img_cover.format = format
    img_cover
  end
  
  def circle(container, left_radius, right_radius)
    cfg = @wheel.render_configuration
    
    container.path("M -#{left_radius},0 A#{left_radius},#{left_radius} 0 0,0 #{left_radius},0 L -#{left_radius},0").rotate(90).styles(:fill => '#FFFFFF', :stroke => 'black', :stroke_width => cfg[:stroke_width].to_f)
    container.path("M -#{right_radius},0 A#{right_radius},#{right_radius} 0 0,0 #{right_radius},0 L -#{right_radius},0").rotate(-90).styles(:fill => '#FFFFFF', :stroke => 'black', :stroke_width => cfg[:stroke_width].to_f)
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
