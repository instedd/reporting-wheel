require 'rvg/rvg'
require 'pdf/writer'
include Magick

RVG::dpi = 72

class RvgBuilder
  
  def initialize(width, height)
    @pdf = PDF::Writer.new(:paper => "A4")
    @width = width
    @height = height
    
    init_rvg
  end
  
  def translate(x, y)
    @last.translate(x, y) do |group|
      tmp = @last
      @last = group
      yield
      @last = tmp
    end
    self
  end
  
  def circle(radius)
    @last.circle(radius).styles(:fill => 'black')
    self
  end
  
  def rect(x, y, width, height)
    @last.rect(width, height, x, y).styles(:fill => 'transparent', :stroke => 'black', :stroke_width => 2)
    self
  end
  
  def stroke
    # @context.stroke
    self
  end
  
  def fill
    # @context.fill
    self
  end
  
  def semi_circle(radius_left, radius_right)
    @last.path("M -#{radius_left},0 A#{radius_left},#{radius_left} 0 0,0 #{radius_left},0 L -#{radius_left},0").rotate(90).styles(:fill => 'transparent', :stroke => 'black', :stroke_width => 2)
    @last.path("M -#{radius_right},0 A#{radius_right},#{radius_right} 0 0,0 #{radius_right},0 L -#{radius_right},0").rotate(-90).styles(:fill => 'transparent', :stroke => 'black', :stroke_width => 2)
    self
  end
  
  def arc(radius, from_angle, to_angle)
    # @context.arc(0, 0, radius, from_angle, to_angle)
    self
  end
  
  def line(x, y)
    # @context.line_to(x, y)
    self
  end
  
  def new_page
    img = @rvg.draw
    img.format = 'JPG'
    
    @pdf.add_image(img.to_blob {self.quality = 100}, 0 ,0, img.columns, img.rows)
    @pdf.start_new_page
    
    init_rvg
    
    self
  end
  
  def image(path)
    self
  end
  
  def text(text, font_size, font_family, x, y, angle, anchor)
    @last.text(x, y, text).rotate(angle).styles(:text_anchor =>'start', :font_size => font_size,
     :font_family => font_family, :fill => 'black')
    self
  end
  
  def build
    File.open("rvg.pdf", "wb") { |f| f.write @pdf.render }
  end
  
  private
  
  def init_rvg
    @rvg = RVG.new(@width, @height)
    @rvg.background_fill = 'red'
    @last = @rvg
  end
  
end