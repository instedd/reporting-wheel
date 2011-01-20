require 'tempfile'

class WheelController < AuthController
  
  before_filter :find_wheel, :only => [:draw_text, :draw, :draw_blank_cover, :draw_preview, :edit, :update, :show, :delete, :should_recalculate]
  
  def index
    @wheels = Wheel.find(:all, :conditions => {:user_id => current_user.id})
  end
  
  def new
    @wheel = Wheel.new
    @wheel.ok_text = "Your report of {Quantity} {Type} of {Disease} was received. Thank you!"
    
    defaults = [['Disease', 'Malaria', 'Flu', 'Cholera'], ['Quantity', '1', '2', '3'], ['Type', 'Cases', 'Deaths']]
    defaults.each_with_index do |values, index| 
      row = @wheel.rows.build
      row.label = values[0]
      row.index = index
      values[1 .. -1].each do |value|
        row_value = row.values.build
        row_value.value = value
      end
    end
  end
  
  def create
    @wheel = Wheel.new(params[:wheel])
    @wheel.user = current_user
    # TODO this hardcodes wheels to a default pool, remove when we add selection of pools
    @wheel.pool = Pool.first
    
    if @wheel.save
      flash[:notice] = "Wheel \"#{@wheel.name}\" created"
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end
  
  def edit
    @wheel.rows.sort!
  end
  
  def should_recalculate
    render :json => recalculate_factors(params[:wheel])
  end
  
  def update 
    @wheel.recalculate_factors = recalculate_factors(params[:wheel])
    if @wheel.update_attributes(params[:wheel])
      flash[:notice] = "Wheel \"#{@wheel.name}\" udpated"
      redirect_to :action => 'index'
    else
      render :action => 'edit'
    end
  end
  
  def show
  end
  
  def delete
    @wheel.destroy
    flash[:notice] = "Wheel \"#{@wheel.name}\" deleted"
    redirect_to :action => 'index'
  end
  
  def draw
    file = temp_file
    builder = CairoPdfBuilder.new(file)
    drawer = WheelDrawer.new(@wheel, builder)
    drawer.draw
    send_file(file, :disposition => 'inline', :type => 'application/pdf', :filename => "wheel_#{@wheel.name}.pdf")
  end
  
  def draw_blank_cover
    file = temp_file
    builder = CairoImageBuilder.new(file)
    drawer = WheelDrawer.new(@wheel, builder)
    drawer.draw_cover
    send_file(file, :disposition => 'attachment', :type => 'image/png', :filename => "wheel_#{@wheel.name}_cover.png")
  end
  
  def draw_preview
    file = temp_file
    builder = CairoSvgBuilder.new(file)
    drawer = WheelDrawer.new(@wheel, builder)
    drawer.draw_preview
    
    content = File.open(file).read
    @svg, @center_x, @center_y = prepare_svg content
    
    render :action => "draw_preview", :content_type => "application/xhtml+xml"
  end
  
  def update_print_configuration
    wheel = Wheel.find(params[:id])
    wheel.update_attributes(params[:wheel])
    
    file = temp_file
    builder = CairoSvgBuilder.new(file)
    drawer = WheelDrawer.new(wheel, builder)
    drawer.draw_preview
    
    content = File.open(file).read
    svg, center_x, center_y = prepare_svg content
    
    render :json => {:svg => svg, :center_x => center_x, :center_y => center_y}
  end
  
  private
  
  def prepare_svg(svg)
    # remove xml header from svg content
    svg = svg[38..-1]
    # capture center of translation so we know where is the center of the wheel
    match = svg.match /1,0,0,1,(\d+\.\d+),(\d+.\d+)/
    center_x = match[1]
    center_y = match[2]
    [svg, center_x, center_y]
  end
  
  def recalculate_factors(wheel_data)
    # TODO: this is ugly, change when ActiveRecord::Dirty supports associations
    # This creates an array where each position belongs to a row and has the number 
    # of values inside that row (rows are sorted by its index)
    rows = wheel_data['wheel_rows_attributes'].map{ |k,v| v } # Get row attributes
    row_lengths = rows.sort{ |a,b| a['index'].to_i <=> b['index'].to_i } \
      .select{ |x| x['_destroy'] != '1' } \
      .map{ |x| x['wheel_values_attributes'].select{|k,v| v['_destroy'] != '1' }.length }
    @wheel.recalculate_factors? row_lengths
  end
    
  def find_wheel
    @wheel = Wheel.find_by_id_and_user_id params[:id], current_user.id, :include => {:wheel_rows => :wheel_values}
    redirect_to :action => :index if not @wheel
  end
  
  def temp_file
    Dir::tmpdir + File::SEPARATOR + 'wheel-file' + Time.now.to_i.to_s
  end
  
end
