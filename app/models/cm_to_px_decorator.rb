class CmToPxDecorator
  
  @@cm_to_px = 28
  
  def initialize(decorated)
    @decorated = decorated
  end
  
  def init(width, height)
    @decorated.init(px(width), px(height))
  end
  
  def translate(x, y, &b)
    @decorated.translate(px(x), px(y), &b)
  end
  
  def circle(radius)
    @decorated.circle(px(radius))
  end
  
  def semi_circle(radius_left, radius_right)
    @decorated.semi_circle(px(radius_left), px(radius_right))
  end
  
  def arc(radius, from_angle, to_angle)
    @decorated.arc(px(radius), from_angle, to_angle)
  end
  
  def line(x, y)
    @decorated.line(px(x), px(y))
  end
  
  def text(text, font_size, font_family, x, y, angle, anchor)
    @decorated.text(text, font_size, font_family, px(x), px(y), angle, anchor)
  end
  
  def rect(x, y, width, height)
    @decorated.rect(px(x), px(y), px(width), px(height))
  end
  
  def method_missing(sym, *args, &b)
    @decorated.send sym, *args, &b
  end
  
  private
  
  def px(cm)
    cm * @@cm_to_px
  end
  
  
end