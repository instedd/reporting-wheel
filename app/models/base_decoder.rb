class BaseDecoder
  def initialize(pool, wheel, message)
    @pool = pool
    @wheel = wheel
    @wheel_size = @wheel.rows.length
    @message = message
    @digits = []
    @values = {}
  end

  def decode
    raise NotImplementedError.new
  end

  def extract_codes(digits)
    size = digits.length / 3
    size.times.map{|i| digits[3*i..3*i+2].to_i}.reverse
  end

  def append_values(wheel_values)
    wheel_values.each do |wheel_value|
      label = wheel_value.row.label
      value = wheel_value.value
      @values[label] ||= []
      @values[label] << value
    end
  end
end
