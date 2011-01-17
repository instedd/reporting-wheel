class WheelDrawer
  
  @@small_space = 0.1
  @@bullseye_size = 0.1
  
  def initialize(wheel, builder)
    @wheel = wheel
    @builder = CmToPxDecorator.new(builder)
    @cfg = @wheel.render_configuration
    @row_drawer = new_design ? NewRowDrawer.new(@wheel, @builder) : RowDrawer.new(@wheel, @builder)
  end
  
  def draw
    @builder.init(width, height)
    
    # draw each row
    @wheel.rows.sort.each_with_index do |row, index|
      @builder.translate((initial_radius + @@small_space), (initial_radius + @@small_space)) do
        @row_drawer.draw_row(row, index)
      end
      @builder.new_page
    end
    
    # draw front cover
    if @wheel.cover_image_path
      draw_image_cover
    else
      @row_drawer.draw_front_cover
    end
    
    @builder.new_page
    
    # draw back cover
    draw_back_cover
      
    @builder.build
  end
  
  def draw_cover
    @builder.init(width, height)
    @row_drawer.draw_front_cover
    @builder.build
  end
  
  def draw_preview
    size = initial_radius * 2 + 0.2
    
    @builder.init(size, size)
    
    # draw each row
    @wheel.rows.sort.each_with_index do |row, index|
      @builder.translate((initial_radius + @@small_space), (initial_radius + @@small_space)) do
        @builder.group do
          @row_drawer.draw_row(row, index)
        end
      end
    end
    
    # draw front cover
    @row_drawer.draw_front_cover
    
    @builder.build
  end
  
  private
  
  def draw_image_cover
    @builder.image("public/" + @wheel.cover_image_path)
  end
  
  def draw_back_cover
    radius = initial_radius
    @builder.translate(radius + @@small_space, radius + @@small_space) do
      @builder.circle(radius).stroke(stroke_width)
      @builder.circle(@@bullseye_size).fill
    end
  end
  
  def initial_radius
    @cfg.initial_radius.to_f
  end
  
  def stroke_width
    @cfg.stroke_width.to_f
  end
  
  def width
    @cfg.width.to_f
  end
  
  def height
    @cfg.height.to_f
  end
  
  def new_design
    @cfg.new_design.to_s == "true"
  end
  
end