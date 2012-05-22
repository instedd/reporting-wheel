class StrictDecoder < BaseDecoder

  @@separator = /[\s|-]+/
  @@stric_regexp = /^(((\d\d\d)+)[\s|-]+)*((\d\d\d)+)$/

  def decode
    raise "Only codes are allowed" unless @@stric_regexp.match @message
    parts = @message.split(@@separator)

    success_messages = []
    values = parts.map do |digits|
      success_message = @wheel.ok_text || ''
      success_messages << success_message

      @digits.push(digits)
      codes = extract_codes(digits)
      values = @wheel.values_for(codes)
      if (values.length == @wheel_size) && (!values.include?(nil))
        values.map do |v|
          success_message.gsub! "{#{v.row.label}}", v.value
          v.row.label + ':"' + v.value + '"'
        end.join(', ')
      else
        raise "Code not found"
      end
    end
    output_str = values.join(' ')

    [output_str, success_messages.join(' - '), @digits]
  end

end
