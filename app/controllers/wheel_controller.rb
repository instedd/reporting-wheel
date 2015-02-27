class WheelController < AuthController

  before_filter :find_wheel, :only => [:draw_text, :draw, :draw_blank_cover, :draw_preview, :draw_preview_png, :edit, :update, :show, :delete, :should_recalculate, :reports]

  def index
    @wheels = Wheel.where(:user_id => current_user.id)
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
    @wheel = Wheel.new(params.permit![:wheel])
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
    @wheel.rows.to_a.sort!
  end

  def should_recalculate
    render :json => recalculate_factors(params.permit![:wheel])
  end

  def update
    @wheel.recalculate_factors = recalculate_factors(params.permit![:wheel])
    if @wheel.update_attributes(params.permit![:wheel])
      flash[:notice] = "Wheel \"#{@wheel.name}\" udpated"
      redirect_to :action => 'show'
    else
      render :action => 'edit'
    end
  end

  def show
    @records_count = WheelRecord.where(:wheel_id => @wheel).count
  end

  def reports
    @records = WheelRecord.where(:wheel_id => @wheel).order('created_at DESC')
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
  end

  def update_print_configuration
    wheel = Wheel.find(params.permit![:id])
    wheel.update_attributes(params.permit![:wheel])

    # HACK update_attributes on wheel doesn't forward
    # the render_configuration to the rows
    params.permit![:wheel]["wheel_rows_attributes"].each do |k,v|
      r = wheel.rows[k.to_i]
      r.update_attributes(v)
    end

    file = temp_file
    builder = CairoSvgBuilder.new(file)
    drawer = WheelDrawer.new(wheel, builder)
    drawer.draw_preview

    content = File.open(file).read
    svg, center_x, center_y = prepare_svg content

    render :json => {:svg => svg, :center_x => center_x, :center_y => center_y}
  end

  def draw_preview_png
    file = temp_file
    builder = CairoImageBuilder.new(file)
    drawer = WheelDrawer.new(@wheel, builder)
    drawer.draw_preview
    send_file(file, :disposition => 'inline', :type => 'image/png')
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
    @wheel = Wheel.includes(:wheel_rows => :wheel_values).find_by_id_and_user_id params.permit![:id], current_user.id
    redirect_to :action => :index if not @wheel
  end

  def temp_file
    Dir::tmpdir + File::SEPARATOR + 'wheel-file' + Time.now.to_i.to_s
  end

end
