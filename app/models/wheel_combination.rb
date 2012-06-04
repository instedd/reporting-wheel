# Represents a particular combination of a wheel. That is, a wheel
# with some values selected.
class WheelCombination
  # This regexp matches consecutives groups of 3 digits
  # (not a digit or the beggining of the string) - ((three digits) one or more times) - (not a digit or the end of the string)
  @@regexp = /(?:[^\d]|^)((?:\d\d\d)+)(?:[^\d]|$)/

  # The wheel of this combination
  attr_reader :wheel

  # The original body of the message
  attr_reader :original

  # The original digits that produced this combination
  attr_reader :digits

  # A human readable message of this combination
  attr_reader :message

  def initialize(pool, body, metadata = {})
    match = @@regexp.match body
    raise "No wheel code present in the message" unless match

    @original_metadata = metadata
    @original = String.new(body)
    @pool = pool

    @wheel = find_wheel(body)

    decoder = @wheel.allow_free_text ? FreeTextDecoder : StrictDecoder

    @message, @success_message, @digits = decoder.new(@pool, @wheel, body).decode
  end

  # Saves this combination as a WheelRecord.
  def record!
    WheelRecord.create! :wheel => @wheel, :code => @digits.join(','), :data => (YAML.dump(@original_metadata) || ""), :original => @original, :decoded => @message
    enqueue_callback
  end

  def wheel_success_message
    @wheel.ok_text.present? ? @success_message : ''
  end

  private

  def find_wheel(message)
    message.scan(/[\d\d\d]+/) do |match|
      # factorize codes to find factors
      begin
        factors = extract_codes(match).map{|c| Prime.factorize c}
        wheel = Wheel.find_for_factors_and_pool factors, @pool
        return wheel unless wheel.nil?
      rescue
        next
      end
    end
    raise "Wheel not found"
  end

  def extract_codes(digits)
    size = digits.length / 3
    size.times.map{|i| digits[3*i..3*i+2].to_i}.reverse
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
