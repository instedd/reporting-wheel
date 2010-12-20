class StrictDecoder < BaseDecoder
  
  @@separator = /[\s|-]+/
  @@stric_regexp = /^(((\d\d\d)+)[\s|-]+)*((\d\d\d)+)$/
  
  def decode
    raise "Only codes are allowed" unless @@stric_regexp.match @message
    parts = @message.split(@@separator)
    values = parts.map do |digits|
      @digits.push(digits)
      codes = extract_codes(digits)
      values = @wheel.values_for(codes)
      if (values.length == @wheel_size) && (!values.include?(nil))
        values.map{|v| v.row.label + ":" + v.value}.join(', ')
      else
        raise "Code not found"
      end
    end
    output_str = values.join(' ')
    
    [output_str, @digits]
  end
  
end