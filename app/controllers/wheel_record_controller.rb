class WheelRecordController < AuthController
  def index
    @wheel = Wheel.find_by_id_and_user_id params[:id], current_user.id
    @records = WheelRecord.find :all, :conditions => {:wheel_id => @wheel}, :order => 'created_at DESC'
  end
end