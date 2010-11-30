class CairoPdfBuilder < CairoBuilder
  
  def init(width, height)
    @width = width
    @height = height
    
    @surface = Cairo::PDFSurface.new(@file_path, width, height)
    @context = Cairo::Context.new(@surface)
  end
  
  def build
    @surface.finish
  end
  
end