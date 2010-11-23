require 'tempfile'

class WheelController < ApplicationController
  
  before_filter :find_wheel, :only => [:draw_text, :draw, :draw_blank_cover, :draw_preview, :edit, :update, :show, :delete, :should_recalculate]
  
  def index
    @wheels = Wheel.all
  end
  
  def new
    @wheel = Wheel.new
    @wheel.ok_text = "Your report of {Quantity} {Type} of {Disease} was received. Thank you!"
    
    defaults = [['Disease', 'Malaria', 'Flu', 'Cholera'], ['Quantity', '1', '2', '3'], ['Type', 'Cases', 'Deaths']]
    defaults.each do |values| 
      row = @wheel.rows.build
      row.label = values[0] 
      values[1 .. -1].each do |value|
        row_value = row.values.build
        row_value.value = value
      end
    end
  end
  
  def create
    @wheel = Wheel.new(params[:wheel])
    
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
    # send_file(file, :disposition => 'inline', :type => 'image/svg+xml', :filename => "wheel_#{@wheel.name}_preview.svg")
    # render :text => File.open(file).read
    @content = File.open(file).read[38..-1]
    render :layout => false, :content_type => "application/xhtml+xml"
  end
  
  private
  
  def recalculate_factors(wheel_data)
    # this is ugly, change when ActiveRecord::Dirty supports associations
    row_lengths = wheel_data['wheel_rows_attributes'].select{|k,v|v['_destroy'] != '1'}.map{|k,v|v['wheel_values_attributes'].select{|k,v|v['_destroy'] != '1'}.length}
    @wheel.recalculate_factors? row_lengths
  end
    
  def find_wheel
    @wheel = Wheel.find_by_id params[:id], :include => {:wheel_rows => :wheel_values}
    redirect_to :action => :index if not @wheel
  end
  
  def temp_file
    Dir::tmpdir + File::SEPARATOR + 'wheel-file' + Time.now.to_i.to_s
  end
  
end
