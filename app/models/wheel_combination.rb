# Represents a particular combination of a wheel. That is, a wheel
# with some values selected.
class WheelCombination
  @@regexp = /(?:[^\d]|^)((?:\d\d\d)+)(?:[^\d]|$)/

  # The wheel of this combination
  attr_reader :wheel
  
  # The values of this combination
  attr_reader :values
  
  # The original body of the message
  attr_reader :original
  
  # The original digits that produced this combination
  attr_reader :digits
  
  # A human readable message of this combination
  attr_reader :message
  
  def initialize(body, metadata = {})
    match = @@regexp.match body
    raise "No wheel code present in the message" unless match
   
    @original_metadata = metadata
    @original = String.new(body)
    @digits = []
    @message = body
    
    # digits from regexp match
    digits = match[1]
    # set wheel size
    @wheel_size = digits.length / 3    
    # factorize codes to find factors
    factors = extract_codes(digits).map{|c| Prime.factorize c}
    
    # find wheel
    @wheel = Wheel.find_for_factors factors
    raise "Wheel not found" if @wheel.nil?
    
    # Decoding
    begin
      # extract codes
      @digits.push(match[1])
      codes = extract_codes(match[1]) 
      
      # find values
      @values = codes.map_with_index{|c,i| WheelValue.find_for(@wheel, i, c)}
    
      # replace in message
      @message[match.begin(1)..match.end(1)-1] = values.map{|v| v.row.label + ":" + v.value}.join(', ')
    end while (match = @@regexp.match @message)
  end
  
  # Saves this combination as a WheelRecord.
  def record!
    WheelRecord.create! :wheel => @wheel, :code => @digits.join(','), :data => (YAML.dump(@original_metadata) || ""), :original => @original, :decoded => @message
    enqueue_callback
  end
  
  private
  
  def extract_codes(digits)
    @wheel_size.times.map{|i| digits[3*i..3*i+2].to_i}.reverse
  end
  
  # Enqueues a callback job if the wheel has a callback url.
  def enqueue_callback
    return unless @wheel.has_callback?
    
    # Add raw decoded values to metadata to push everything to the callback
    # callback_metadata = @original_metadata.merge @values.inject({}){|h,e| h[e.row.label] = e.value ; h}
    callback_metadata = @original_metadata
    
    Delayed::Job.enqueue DecodeCallbackJob.new(@wheel.url_callback, @message, callback_metadata)
  end
end
