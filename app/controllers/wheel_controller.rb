require 'rvg/rvg'
require 'pdf/writer'
include Magick

RVG::dpi = 144

class WheelController < ApplicationController
  
  before_filter :find_wheel, :only => [:draw_text, :draw, :edit, :update, :show, :delete, :should_recalculate]
  
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
    @wheel.rows.sort!
  end
  
  def should_recalculate
    render :json => recalculate_factors(params[:wheel])
  end
  
  def update 
    @wheel.recalculate_factors = recalculate_factors(params[:wheel])
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
  
    pdf = PDF::Writer.new(:paper => "A4")
    
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
          
          row_values_count = row.values.length
          indexes = (0..row_values_count-1).map{|z| z - row_values_count/2}.reverse
           
          row.values.sort.each_with_index do |value, j|
            angle = (cfg[:angle_separation].to_f + i * cfg[:angle_modifier].to_f) * indexes[j]
            angle_rad = to_rad angle
            
            margin = (i > 0 ? cfg[:inner_margin] : cfg[:outer_margin]).to_f.cm

            dx, dy = point_for_angle(-(left_radius - margin), angle_rad)
            group.text(dx, dy, value.value).rotate(angle).styles(:text_anchor =>'start', :font_size => cfg[:values_font_size].to_f,
             :font_family => cfg[:values_font_family], :fill => 'black')
             
            #Force codes to have 3 digits (pad with leading zeros)
            dx, dy = point_for_angle((right_radius - margin), angle_rad)
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
    
    # Draw wheel back cover
    pdf.start_new_page
    draw_back_cover_on pdf
        
    send_data(pdf.render , :disposition => 'inline', :type => 'application/pdf', :filename => "wheel_#{@wheel.name}.pdf")
  end
  
  def draw_blank_cover
    img_cover = blank_cover_image params[:rows_count].to_i, 'PNG'
    send_data(img_cover.to_blob, :disposition => 'inline', :type => 'application/png', :filename => 'wheel_blank_cover.png')
  end
  
  private
  
  def recalculate_factors(wheel_data)
    # this is ugly, change when ActiveRecord::Dirty supports associations
    row_lengths = wheel_data['wheel_rows_attributes'].select{|k,v|v['_destroy'] != '1'}.map{|k,v|v['wheel_values_attributes'].select{|k,v|v['_destroy'] != '1'}.length}
    @wheel.recalculate_factors? row_lengths
  end
  
  def draw_back_cover_on(pdf)
    cfg = @wheel.render_configuration
    
    rvg_back_cover = RVG.new(cfg[:width].to_f.cm, cfg[:height].to_f.cm) do |canvas|
      canvas.background_fill = 'white'
      radius = cfg[:initial_radius].to_f
      
      canvas.g.translate(radius.cm + 0.1.cm, radius.cm + 0.1.cm) do |g|
         g.circle(radius.cm).styles(:fill => '#FFFFFF', :stroke => 'black', :stroke_width => cfg[:stroke_width].to_f)
         g.circle(0.1.cm).styles(:fill => 'black')
      end
    end
    
    img_back_cover = rvg_back_cover.draw
    img_back_cover.format = 'JPG'
    
    pdf.add_image(img_back_cover.to_blob {self.quality = 100}, 0 ,0, img_back_cover.columns * 0.5, img_back_cover.rows * 0.5)
  end
  
  def draw_blank_cover_on(pdf)
    # Draw wheel cover
    img_cover = blank_cover_image(@wheel.rows.length, 'JPG')
    pdf.add_image(img_cover.to_blob {self.quality = 100}, 0 ,0, img_cover.columns * 0.5, img_cover.rows * 0.5)
  end
  
  def blank_cover_image(rows_count, format)
    cfg = @wheel.render_configuration
    
    initial_radius = cfg[:initial_radius].to_f
  
    rvg_cover = RVG.new(cfg[:width].to_f.cm, cfg[:height].to_f.cm) do |canvas|
      canvas.background_fill = 'white'
      
      canvas.g.translate(initial_radius.cm + 0.1.cm, initial_radius.cm + 0.1.cm) do |g|
        
        g.circle(0.1.cm).styles(:fill => 'black')
        
        dx, dy = point_for_angle(initial_radius.cm, to_rad(60))
        
        g.path("M#{-initial_radius.cm},0 A#{initial_radius.cm},#{initial_radius.cm} 0 0,0 #{initial_radius.cm},0").rotate(180).styles(:fill => 'transparent', :stroke => 'black', :stroke_width => cfg[:stroke_width].to_f)
        g.path("M#{initial_radius.cm},0 A#{initial_radius.cm},#{initial_radius.cm} 0 0,0 #{dx},#{-dy}").rotate(180).styles(:fill => 'transparent', :stroke => 'black', :stroke_width => cfg[:stroke_width].to_f)
        g.path("M#{initial_radius.cm},0 A#{initial_radius.cm},#{initial_radius.cm} 0 0,0 #{dx},#{-dy}").rotate(60).styles(:fill => 'transparent', :stroke => 'black', :stroke_width => cfg[:stroke_width].to_f)
        
        minor_radius = 2.cm
        
        dx, dy = point_for_angle(minor_radius, to_rad(60))
        g.path("M#{minor_radius},0 A#{minor_radius},#{minor_radius} 0 0,0 #{dx},#{-dy}").rotate(120).styles(:fill => 'transparent', :stroke => 'black', :stroke_width => cfg[:stroke_width].to_f)
        
        x1, y1 = point_for_angle(initial_radius.cm, to_rad(240))
        x2, y2 = point_for_angle(minor_radius, to_rad(240))
        g.line(x1, -y1, x2, -y2).styles(:stroke => 'black', :stroke_width => cfg[:stroke_width].to_f)
        
        x1, y1 = point_for_angle(initial_radius.cm, to_rad(300))
        x2, y2 = point_for_angle(minor_radius, to_rad(300))
        g.line(x1, -y1, x2, -y2).styles(:stroke => 'black', :stroke_width => cfg[:stroke_width].to_f)
        
        # draw left boxes (boxes for values)
        rows_count.times do |i|
          dx = (- initial_radius + accumulated_values_width_for_index(i) + i * cfg[:row_separation].to_f + i * cfg[:inner_margin].to_f + cfg[:outer_margin].to_f).cm
          dy = (- cfg[:field_cover_height].to_f / 2 - 0.1).cm
          g.rect(values_width_for_index(i).cm, cfg[:field_cover_height].to_f.cm, dx, dy).styles(:fill => 'transparent', :stroke => 'black', :stroke_width => cfg[:stroke_width].to_f)
        end
        
        # draw right box (box for code)
        width = (rows_count * cfg[:codes_width].to_f + (rows_count - 1) * (cfg[:row_separation].to_f + cfg[:inner_margin].to_f)).cm
        height = cfg[:field_cover_height].to_f.cm
        dx = initial_radius.cm - width - cfg[:outer_margin].to_f.cm
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
  
  def point_for_angle(length, angle_rad)
    [length * Math.cos(angle_rad), length * Math.sin(angle_rad)]
  end
  
  def values_width_for_index(i)
    case i
    when 0
      @wheel.render_configuration[:values_width_field_1].to_f
    when 1
      @wheel.render_configuration[:values_width_field_2].to_f
    when 2
      @wheel.render_configuration[:values_width_field_3].to_f
    else
      @wheel.render_configuration[:values_width].to_f
    end
  end
  
  def accumulated_values_width_for_index(i)
    return 0 if i == 0
  
    sum = 0
    0.upto(i - 1) do |x|
      sum += values_width_for_index x
    end
    sum 
  end
  
  def find_wheel
    @wheel = Wheel.find_by_id params[:id], :include => {:wheel_rows => :wheel_values}
    redirect_to :action => :index if not @wheel
  end
  
end
