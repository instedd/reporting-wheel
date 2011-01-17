class NewRowDrawer < BaseRowDrawer
  
  def draw_front_cover
    rows_count = @wheel.rows.length
    
    @builder.translate(initial_radius + @@small_space, initial_radius + @@small_space) do
      # Draw bullseye
      @builder.circle(@@bullseye_size).fill
      
      # Border for cover
      minor_radius =  [calculate_radius(rows_count), @@cover_window_radius].min
      @builder.arc(initial_radius, to_rad(-240), to_rad(60))
      x, y = point_for_angle(minor_radius, to_rad(60))
      @builder.line(x,y)
      @builder.arc(minor_radius, to_rad(60), to_rad(120))
      x, y = point_for_angle(initial_radius, to_rad(-240))
      @builder.line(x, y)
      @builder.stroke(stroke_width)
      
      # Draw left boxes (boxes for values)
      rows_count.times do |i|
        dx = - initial_radius + values_offset(i) + row_separation_offset(i) + margin_offset(i+1) + codes_offset(i) + value_code_space_offset(i) - @@small_space
        dy = - field_cover_height / 2
        width = values_width_for_index(i) + @@small_space
        height = field_cover_height
        @builder.rect(dx, dy, width, height).stroke(stroke_width)
      end
      
      # Draw right boxes (boxes for codes)
      rows_count.times do |i|
        dx = initial_radius - values_offset(i+1) - row_separation_offset(i) - margin_offset(i+1) - codes_offset(i+1) - value_code_space_offset(i+1) + @@small_space
        dy = - field_cover_height / 2
        width = codes_width + @@small_space
        height = field_cover_height
        @builder.rect(dx, dy, width, height).stroke(stroke_width)
      end
    end
  end
  
  def draw_row(row, i)
    # Radius for this row
    radius = calculate_radius(i)
    
    # Draw circle for the row
    @builder.circle(radius).stroke(stroke_width)
    
    # Calculate indexes
    row_values_count = row.values.length
    indexes = (0..row_values_count-1).map{|z| z - row_values_count/2}.reverse
    
    # Draw each pair of value/code
    row.values.sort.each_with_index do |value, j|
      # Angle for this value/code
      angle = (angle_separation + i * angle_modifier) * indexes[j]
      angle_rad = to_rad angle
      
      # Margin from wheel border to text, use outer_margin for the first row, else inner_margin
      margin = i > 0 ? inner_margin : outer_margin
      
      # Color for the value/code text
      color = alternate_colors && j % 2 == 0 ?  @@color_grey : @@color_black
      
      # Draw value
      dx, dy = point_for_angle(-(radius - margin), angle_rad)
      @builder.text(value.value, values_font_size, values_font_family, color, dx, dy, angle_rad, :left)
       
      # Draw code (padded with ceros to be 3 digits length)
      dx, dy = point_for_angle((radius - margin - values_width_for_index(i) - value_code_space), angle_rad)
      @builder.text("%03d" % value.code, codes_font_size, codes_font_family, color, dx, dy, angle_rad, :right)
    end
    
    # Draw bullseye
    @builder.circle(@@bullseye_size).fill
  end
  
  private
  
  def calculate_radius(i)
    initial_radius - values_offset(i) - row_separation_offset(i) - margin_offset(i) - codes_offset(i) - value_code_space_offset(i)
  end
  
end