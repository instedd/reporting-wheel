class CairoSvgBuilder < CairoImageBuilder
  
  def init(width, height)
    @width = width
    @height = height
    @surface = Cairo::SVGSurface.new(@file_path, width, height)
    @context = Cairo::Context.new(@surface)
  end
  
  def group
    @context.save
    @context.push_group 
    yield
    @context.pop_group(true)
    @context.paint
    @context.restore
  end
  
  def build
    @surface.finish
  end
  
end