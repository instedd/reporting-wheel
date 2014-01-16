require 'csv'

class WheelRecordController < AuthController
  before_filter :load, only: [:index, :csv]

  def index
    @wheel = Wheel.find_by_id_and_user_id params[:id], current_user.id
    @records = WheelRecord.where(:wheel_id => @wheel).order('created_at DESC')
  end

  def csv
    labels = @wheel.rows.map(&:label)

    data = CSV.generate do |csv|
      csv << ["Date", "Code", "Data", "Original"] + labels
      @records.each do |record|
        values = labels.map{|l| record.values_for(l)}
        csv << [record.created_at, record.code, record.data_str, record.original] + values
      end
    end

    send_data data, filename: "#{@wheel.name}_records.csv"
  end

private

  def load
    @wheel = Wheel.find_by_id_and_user_id params[:id], current_user.id
    @records = WheelRecord.where(:wheel_id => @wheel).order('created_at DESC')
  end

end
