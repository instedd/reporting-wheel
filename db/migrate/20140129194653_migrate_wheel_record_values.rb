class MigrateWheelRecordValues < ActiveRecord::Migration

  class ::Array
    def map_with_index!
       each_with_index do |e, idx| self[idx] = yield(e, idx); end
    end

    def map_with_index(&block)
      dup.map_with_index!(&block)
    end
  end

  class Wheel < ActiveRecord::Base
    has_many :wheel_records
    has_many :wheel_rows
    alias :rows :wheel_rows

    def values_for(codes)
      codes.map_with_index{|c,i| WheelValue.find_for(self, i, c)}
    end
  end

  class WheelRow < ActiveRecord::Base
    belongs_to :wheel
  end

  class WheelValue < ActiveRecord::Base
    belongs_to :wheel_row
    alias :row :wheel_row

    def self.find_for(wheel, index, code)
      WheelValue.find :first, :include => {:wheel_row => :wheel},
                              :conditions => ["wheels.id = ? AND wheel_rows.index = ? AND wheel_values.code = ?",
                                              wheel.id, index, code]
    end
  end

  class WheelRecord < ActiveRecord::Base
    serialize :values, Hash
  end

  def self.up
    Wheel.all.each do |wheel|
      decoder = wheel.allow_free_text ? FreeTextDecoder : StrictDecoder
      wheel.wheel_records.each do |record|
        begin
          message, success_message, digits, values = decoder.new(nil, wheel, record.original).decode
          record.values = values
          record.save
        rescue Exception => e
          p "Error migrating wheel #{wheel.id} record #{record.id}. Exception: #{e}"
        end
      end
    end
  end

  def self.down
  end
end
