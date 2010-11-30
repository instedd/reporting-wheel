class CairoImageBuilder < CairoBuilder
  
  def init(width, height)
    @width = width
    @height = height
    @surface = Cairo::ImageSurface.new(width, height)
    @context = Cairo::Context.new(@surface)
  end
  
  def build
    @surface.write_to_png(@file_path)
  end
  
end