class WheelDrawer
  
  @@cover_window_radius = 3
  @@small_space = 0.1
  @@bullseye_size = 0.1
  @@color_black = "#000000"
  @@color_grey = "#666666"
  
  def initialize(wheel, builder)
    @wheel = wheel
    @builder = CmToPxDecorator.new(builder)
    @cfg = @wheel.render_configuration
  end
  
  def draw
    @builder.init(width, height)
    
    # draw each row
    @wheel.rows.sort.each_with_index do |row, index|
      @builder.translate((initial_radius + @@small_space), (initial_radius + @@small_space)) do
        draw_row(row, index)
      end
      @builder.new_page
    end
    
    # draw front cover
    if @wheel.cover_image_path
      draw_image_cover
    else
      draw_front_cover
    end
    
    @builder.new_page
    
    # draw back cover
    draw_back_cover
      
    @builder.build
  end
  
  def draw_cover
    @builder.init(width, height)
    draw_front_cover
    @builder.build
  end
  
  def draw_preview
    size = initial_radius * 2 + 0.2
    
    @builder.init(size, size)
    
    # draw each row
    @wheel.rows.sort.each_with_index do |row, index|
      @builder.translate((initial_radius + @@small_space), (initial_radius + @@small_space)) do
        @builder.group do
          draw_row(row, index)
        end
      end
    end
    
    # draw front cover
    draw_front_cover
    
    @builder.build
  end
  
  private
  
  def draw_front_cover
    rows_count = @wheel.rows.length
    
    @builder.translate(initial_radius + @@small_space, initial_radius + @@small_space) do
      # draw bullseye
      @builder.circle(@@bullseye_size).fill
      
      # border for cover
      minor_radius =  [calculate_right_radius(rows_count), @@cover_window_radius].min
      @builder.arc(initial_radius, to_rad(-240), to_rad(60))
      x, y = point_for_angle(minor_radius, to_rad(60))
      @builder.line(x,y)
      @builder.arc(minor_radius, to_rad(60), to_rad(120))
      x, y = point_for_angle(initial_radius, to_rad(-240))
      @builder.line(x, y)
      @builder.stroke(stroke_width)
      
      # draw left boxes (boxes for values)
      rows_count.times do |i|
        dx = (- initial_radius + accumulated_values_width_for_index(i) + i * row_separation + i * inner_margin + outer_margin) - @@small_space
        dy = - field_cover_height / 2
        @builder.rect(dx, dy, values_width_for_index(i) + @@small_space, field_cover_height).stroke(stroke_width)
      end
      
      # draw right box (box for code)
      width = (rows_count * codes_width + (rows_count - 1) * (row_separation + inner_margin)) + @@small_space
      height = field_cover_height
      dx = initial_radius - width - outer_margin + @@small_space
      dy = - field_cover_height / 2      
      @builder.rect(dx, dy, width, height).stroke(stroke_width)
    end
  end
  
  def draw_image_cover
    @builder.image("public/" + @wheel.cover_image_path)
  end
  
  def draw_back_cover
    radius = initial_radius
    @builder.translate(radius + @@small_space, radius + @@small_space) do
      @builder.circle(radius).stroke(stroke_width)
      @builder.circle(@@bullseye_size).fill
    end
  end
  
  def draw_row(row, i)
    # radius for the left semicircle
    left_radius = calculate_left_radius i
    # radius for the right semicircle
    right_radius = calculate_right_radius i
    
    @builder.semi_circle(left_radius, right_radius).stroke(stroke_width)
    
    row_values_count = row.values.length
    indexes = (0..row_values_count-1).map{|z| z - row_values_count/2}.reverse
     
    row.values.sort.each_with_index do |value, j|
      angle = (angle_separation + i * angle_modifier) * indexes[j]
      angle_rad = to_rad angle
      
      margin = i > 0 ? inner_margin : outer_margin
      color = alternate_colors && j % 2 == 0 ?  @@color_grey : @@color_black
    
      dx, dy = point_for_angle(-(left_radius - margin), angle_rad)
      @builder.text(value.value, values_font_size, values_font_family, color, dx, dy, angle_rad, :left)
       
      #Force codes to have 3 digits (pad with leading zeros)
      dx, dy = point_for_angle((right_radius - margin), angle_rad)
      @builder.text("%03d" % value.code, codes_font_size, codes_font_family, color, dx, dy, angle_rad, :right)
    end
    
    # draw bullseye
    @builder.circle(@@bullseye_size).fill
  end
  
  def calculate_left_radius(i)
    initial_radius - row_left_offset(i) - i * row_separation - ( i > 0 ? outer_margin : 0) - (i > 1 ? (i-1) * inner_margin : 0)
  end
  
  def calculate_right_radius(i)
    initial_radius - i * codes_width - i * row_separation - ( i > 0 ? outer_margin : 0) - (i > 1 ? (i-1) * inner_margin : 0)
  end
  
  def point_for_angle(length, angle_rad)
    [length * Math.cos(angle_rad), length * Math.sin(angle_rad)]
  end
  
  def row_left_offset(row)
    case row
      when 0 
        row_left_offset = 0 
      when 1
        row_left_offset = @cfg[:values_width_field_1].to_f
      when 2
        row_left_offset = @cfg[:values_width_field_1].to_f + @cfg[:values_width_field_2].to_f
      else
        row_left_offset = @cfg[:values_width_field_1].to_f + @cfg[:values_width_field_2].to_f + @cfg[:values_width_field_3].to_f + (row - 3) * @cfg[:values_width].to_f
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
  
  def values_width_for_index(i)
    case i
      when 0
        @cfg[:values_width_field_1].to_f
      when 1
        @cfg[:values_width_field_2].to_f
      when 2
        @cfg[:values_width_field_3].to_f
      else
        @cfg[:values_width].to_f
    end
  end
  
  def to_rad(angle)
    angle * Math::PI / 180.0
  end
  
  def initial_radius
    @cfg.initial_radius.to_f
  end
  
  def stroke_width
    @cfg.stroke_width.to_f
  end
  
  def row_separation
    @cfg.row_separation.to_f
  end
  
  def inner_margin
    @cfg.inner_margin.to_f
  end
  
  def outer_margin
    @cfg.outer_margin.to_f
  end
  
  def field_cover_height
    @cfg.field_cover_height.to_f
  end
  
  def codes_width
    @cfg.codes_width.to_f
  end
  
  def angle_separation
    @cfg.angle_separation.to_f
  end
  
  def angle_modifier
    @cfg.angle_modifier.to_f
  end
  
  def values_font_size
    @cfg.values_font_size.to_i
  end
  
  def values_font_family
    @cfg.values_font_family
  end
  
  def codes_font_size
    @cfg.codes_font_size.to_i
  end
  
  def codes_font_family
    @cfg.codes_font_family
  end
  
  def width
    @cfg.width.to_f
  end
  
  def height
    @cfg.height.to_f
  end
  
  def alternate_colors
    @cfg.alternate_colors == "true"
  end
  
end