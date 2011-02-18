class RowDrawer < BaseRowDrawer
  
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
        dx = - initial_radius + values_offset(i) + row_separation_offset(i) + margin_offset(i+1) - @@small_space
        dy = - field_cover_height / 2
        @builder.rect(dx, dy, values_width(i) + @@small_space, field_cover_height).stroke(stroke_width)
      end
      
      # draw right box (box for code)
      width = rows_count * codes_width + (rows_count - 1) * (row_separation + inner_margin) + @@small_space
      height = field_cover_height
      dx = initial_radius - width - outer_margin + @@small_space
      dy = - field_cover_height / 2      
      @builder.rect(dx, dy, width, height).stroke(stroke_width)
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
      angle = angle_separation(i) * indexes[j]
      angle_rad = to_rad angle
      
      margin = i > 0 ? inner_margin : outer_margin
      
      if alternate_colors && j % 2 == 0
        # Background for value
        dx = - left_radius + margin - @@small_space
        dy = - field_cover_height / 2
        width = values_width(i) + @@small_space
        height = field_cover_height
        @builder.rotate(angle_rad) do
          @builder.rect(dx, dy, width, height).fill(@@color_grey)
        end
        
        # Background for code
        dx = right_radius - margin - codes_width
        dy = - field_cover_height / 2
        width = codes_width + row_separation 
        height = field_cover_height
        @builder.rotate(angle_rad) do
          @builder.rect(dx, dy, width, height).fill(@@color_grey)
        end
      end
    
      dx, dy = point_for_angle(-(left_radius - margin), angle_rad)
      @builder.text(value.value, values_font_size(i), values_font_family(i), dx, dy, angle_rad, :left)
       
      #Force codes to have 3 digits (pad with leading zeros)
      dx, dy = point_for_angle((right_radius - margin), angle_rad)
      @builder.text("%03d" % value.code, codes_font_size, codes_font_family, dx, dy, angle_rad, :right)
    end
    
    # draw bullseye
    @builder.circle(@@bullseye_size).fill
  end
  
  private
  
  def calculate_left_radius(i)
    initial_radius - values_offset(i) - row_separation_offset(i) - margin_offset(i)
  end
  
  def calculate_right_radius(i)
    initial_radius - codes_offset(i) - row_separation_offset(i) - margin_offset(i)
  end
  
end