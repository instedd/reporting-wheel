# Represents a particular combination of a wheel. That is, a wheel
# with some values selected.
class WheelCombination

  # The wheel of this combination
  attr_reader :wheel
  
  # The values of this combination
  attr_reader :values
  
  # The original digits that produced this combination
  attr_reader :digits
  
  # A human readable message of this combination
  attr_reader :message
  
  def initialize(digits, metadata)
    raise "Only number are allowed" unless /^\d+$/.match(digits)
    raise "The number of digits must be a multiple of 3" unless (digits.length % 3) == 0
   
    @original_metadata = metadata
    
    @digits = digits
    
    # extract codes from id
    count = digits.length / 3
    codes = count.times.map{|i| digits[3*i..3*i+2].to_i}.reverse
    
    # factorize codes to find factors
    # TODO check if factorize fails to find factor
    factors = codes.map{|c| Prime.factorize c}
    
    # find wheel
    @wheel = Wheel.find_for_factors factors
    raise "Wheel not found" if @wheel.nil?
    
    # find values
    @values = codes.map_with_index{|c,i| WheelValue.find_for(@wheel, i, c)}
    
    # human readable message
    @message = values.map{|v| v.row.label + ":" + v.value}.join(',')
  end
  
  # Saves this combination as a WheelRecord.
  def record!
    WheelRecord.create! :wheel => @wheel, :code => @digits, :data => (YAML.dump(@original_metadata) || "")
    enqueue_callback
  end
  
  private
  
  # Enqueues a callback job if the wheel has a callback url.
  def enqueue_callback
    return unless @wheel.has_callback?
    
    # Add raw decoded values to metadata to push everything to the callback
    callback_metadata = @original_metadata.merge @values.inject({}){|h,e| h[e.row.label] = e.value ; h}
    
    Delayed::Job.enqueue DecodeCallbackJob.new(@wheel.url_callback, @message, callback_metadata)
  end
end
