require 'cairo'
require 'pango'

class CairoBuilder
  
  def initialize(file_path)
    @file_path = file_path
  end
  
  def translate(x, y)
    tmp = @context.matrix
    @context.translate(x, y)
    yield
    @context.matrix = tmp
    self
  end
  
  def circle(radius)
    @context.circle(0, 0, radius)
    self
  end
  
  def rect(x, y, width, height)
    @context.rectangle(x, y, width, height)
    self
  end
  
  def stroke(line_width)
    @context.set_line_width(line_width)
    @context.stroke
    self
  end
  
  def fill
    @context.fill
    self
  end
  
  def semi_circle(radius_left, radius_right)
    @context.arc(0, 0, radius_left, 2*Math::PI/4.0, -2*Math::PI/4.0)
    @context.arc(0, 0, radius_right, -2*Math::PI/4.0, 2*Math::PI/4.0)
    @context.close_path
    self
  end
  
  def arc(radius, from_angle, to_angle)
    @context.arc(0, 0, radius, from_angle, to_angle)
    self
  end
  
  def line(x, y)
    @context.line_to(x, y)
    self
  end
  
  def new_page
    @context.show_page
    self
  end
  
  def image(path)
    @context.save
    image_surface = Cairo::ImageSurface.from_png(path)
    @context.set_source(image_surface)
    @context.paint
    @context.restore
  end
  
  def text(text, font_size, font_family, color, x, y, angle, anchor)
    tmp = @context.matrix
    @context.translate(x, y)
    @context.rotate(angle)
    
    pango_layout = @context.create_pango_layout
    
    pango_font_description = Pango::FontDescription.new
    pango_font_description.family = font_family
    pango_font_description.absolute_size = font_size * Pango::SCALE
    pango_layout.font_description = pango_font_description
    
    pango_layout.markup = '<span foreground="' + color + '">' + text + '</span>'
    
    # correct position of text
    size_x, size_y = pango_layout.size.map{|e| e / Pango::SCALE}
    @context.translate(anchor == :right ? -size_x : 0, -size_y / 2)
    
    @context.show_pango_layout(pango_layout)
    @context.matrix = tmp
    
    self
  end
  
end