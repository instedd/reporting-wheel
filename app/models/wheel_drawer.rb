class WheelDrawer
  
  @@minor_radius = 2
  @@small_space = 0.1
  @@bullseye_size = 0.1
  
  def initialize(wheel, builder)
    @wheel = wheel
    @builder = CmToPxDecorator.new(builder)
    @cfg = @wheel.render_configuration
  end
  
  def draw
    @builder.init(25,25)
    
    # draw each row
    @wheel.rows.sort.each_with_index do |row, index|
      @builder.translate((@cfg[:initial_radius].to_f + @@small_space), (@cfg[:initial_radius].to_f + @@small_space)) do
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
    @builder.init(25,25)
    draw_front_cover
    @builder.build
  end
  
  def draw_preview
    size = @cfg[:initial_radius].to_f * 2 + 0.2
    
    @builder.init(size, size)
    
    # draw each row
    @wheel.rows.sort.each_with_index do |row, index|
      @builder.translate((@cfg[:initial_radius].to_f + @@small_space), (@cfg[:initial_radius].to_f + @@small_space)) do
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
    initial_radius = @cfg[:initial_radius].to_f
    rows_count = @wheel.rows.length
    
    @builder.translate(initial_radius + @@small_space, initial_radius + @@small_space) do
      # draw bullseye
      @builder.circle(@@bullseye_size).fill
      
      # border for cover
      @builder.arc(initial_radius, to_rad(-240), to_rad(60))
      x, y = point_for_angle(@@minor_radius, to_rad(60))
      @builder.line(x,y)
      @builder.arc(@@minor_radius, to_rad(60), to_rad(120))
      x, y = point_for_angle(initial_radius, to_rad(-240))
      @builder.line(x, y)
      @builder.stroke
      
      # draw left boxes (boxes for values)
      rows_count.times do |i|
        dx = (- initial_radius + accumulated_values_width_for_index(i) + i * @cfg[:row_separation].to_f + i * @cfg[:inner_margin].to_f + @cfg[:outer_margin].to_f) - @@small_space
        dy = - @cfg[:field_cover_height].to_f / 2
        @builder.rect(dx, dy, values_width_for_index(i) + @@small_space, @cfg[:field_cover_height].to_f).stroke
      end
      
      # draw right box (box for code)
      width = (rows_count * @cfg[:codes_width].to_f + (rows_count - 1) * (@cfg[:row_separation].to_f + @cfg[:inner_margin].to_f)) + @@small_space
      height = @cfg[:field_cover_height].to_f
      dx = initial_radius - width - @cfg[:outer_margin].to_f + @@small_space
      dy = - @cfg[:field_cover_height].to_f / 2      
      @builder.rect(dx, dy, width, height).stroke
    end
  end
  
  def draw_image_cover
    @builder.image("public/" + @wheel.cover_image_path)
  end
  
  def draw_back_cover
    radius = @cfg[:initial_radius].to_f
    @builder.translate(radius + @@small_space, radius + @@small_space) do
      @builder.circle(radius).stroke
      @builder.circle(@@bullseye_size).fill
    end
  end
  
  def draw_row(row, i)
    # radius for the left semicircle
    left_radius = @cfg[:initial_radius].to_f - row_left_offset(i) - i * @cfg[:row_separation].to_f - ( i > 0 ? @cfg[:outer_margin].to_f : 0) - (i > 1 ? (i-1) * @cfg[:inner_margin].to_f : 0)
    # radius for the right semicircle
    right_radius = @cfg[:initial_radius].to_f - i * @cfg[:codes_width].to_f - i * @cfg[:row_separation].to_f - ( i > 0 ? @cfg[:outer_margin].to_f : 0) - (i > 1 ? (i-1) * @cfg[:inner_margin].to_f : 0)
    
    @builder.semi_circle(left_radius, right_radius).stroke
    
    row_values_count = row.values.length
    indexes = (0..row_values_count-1).map{|z| z - row_values_count/2}.reverse
     
    row.values.sort.each_with_index do |value, j|
      angle = (@cfg[:angle_separation].to_f + i * @cfg[:angle_modifier].to_f) * indexes[j]
      angle_rad = to_rad angle
      
      margin = (i > 0 ? @cfg[:inner_margin] : @cfg[:outer_margin]).to_f
    
      dx, dy = point_for_angle(-(left_radius - margin), angle_rad)
      @builder.text(value.value, @cfg[:values_font_size].to_i, @cfg[:values_font_family], dx, dy, angle_rad, :left)
       
      #Force codes to have 3 digits (pad with leading zeros)
      dx, dy = point_for_angle((right_radius - margin), angle_rad)
      @builder.text("%03d" % value.code, @cfg[:codes_font_size].to_i, @cfg[:codes_font_family], dx, dy, angle_rad, :right)
    end
    
    # draw bullseye
    @builder.circle(@@bullseye_size).fill
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
  
end