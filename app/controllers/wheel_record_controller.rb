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
        record.codes.each do |code|
          values = labels.map{|label| record.values_for(code, label)}
          csv << [record.created_at, code, record.data_str, record.original] + values
        end
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
