class WheelRecordController < AuthController
  def index
    @wheel = Wheel.find(params[:id])
    @records = WheelRecord.find :all, :conditions => {:wheel_id => @wheel}, :order => 'created_at DESC'
  end
end