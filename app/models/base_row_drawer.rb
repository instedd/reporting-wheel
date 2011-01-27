class BaseRowDrawer
  
  @@bullseye_size = 0.1
  @@cover_window_radius = 3
  @@small_space = 0.1
  @@color_black = "#000000"
  @@color_grey = "#aaaaaa"
  
  def initialize(wheel, builder)
    @wheel = wheel
    @builder = builder
    @cfg = @wheel.print_config
  end
  
  def draw_front_cover
    raise NotImplementedError.new
  end
  
  def draw_row(row, i)
    raise NotImplementedError.new
  end
  
  protected
  
  def point_for_angle(length, angle_rad)
    [length * Math.cos(angle_rad), length * Math.sin(angle_rad)]
  end
  
  def values_offset(i)
    0.upto(i - 1).inject(0){|r,x| r + values_width(x)}
  end
  
  def row_separation_offset(i)
    i * row_separation
  end
  
  def margin_offset(i)
    # this is the margin for row 0 (outer_margin) plus the margin for row > 0 (inner margin) times [i-1]
    ( i > 0 ? outer_margin : 0) + (i > 1 ? (i-1) * inner_margin : 0)
  end
  
  def codes_offset(i)
    i * codes_width
  end
  
  def value_code_space_offset(i)
    i * value_code_space
  end
  
  def values_width(i)
    @wheel.rows[i].print_config['values_width']
  end
  
  def to_rad(angle)
    angle * Math::PI / 180.0
  end
  
  # Configuration getters
  
  def initial_radius
    @cfg['initial_radius']
  end
  
  def row_separation
    @cfg['row_separation']
  end
  
  def codes_width
    @cfg['codes_width']
  end
  
  def stroke_width
    @cfg['stroke_width']
  end
  
  def angle_separation(i)
    @wheel.rows[i].print_config['angle_separation']
  end
  
  def inner_margin
    @cfg['inner_margin']
  end
  
  def outer_margin
    @cfg['outer_margin']
  end
  
  def alternate_colors
    @cfg['alternate_colors']
  end
  
  def values_font_size(i)
    @wheel.rows[i].print_config['values_font_size']
  end
  
  def values_font_family(i)
    @wheel.rows[i].print_config['values_font_family']
  end
  
  def codes_font_size
    @cfg['codes_font_size']
  end
  
  def codes_font_family
    @cfg['codes_font_family']
  end
  
  def field_cover_height
    @cfg['field_cover_height']
  end
  
  def value_code_space
    @@small_space
  end
  
end