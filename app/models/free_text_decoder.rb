class FreeTextDecoder < BaseDecoder
  
  @@regexp = /(?:[^\d]|^)((?:\d\d\d)+)(?:[^\d]|$)/
  
  def decode
    output_str = ""
    
    while (match = @@regexp.match(@message))
      # extract codes
      codes = extract_codes(match[1])
      
      # find values
      values = @wheel.values_for(codes)

      if (values.length == @wheel_size) && (!values.include?(nil))
        end_pos = match.begin(1) - 1
        output_str += @message[0..end_pos] if end_pos >= 0
        output_str += values.map{|v| v.row.label + ":" + v.value}.join(', ')
        @digits.push(match[1])
      else
        end_pos = match.end(1) - 1
        output_str += @message[0..end_pos] if end_pos >= 0
      end
      
      @message = @message[match.end(1)..-1]
    end
    
    output_str += @message
    
    [output_str, @digits]
  end
  
end