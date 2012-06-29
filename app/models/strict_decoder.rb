class StrictDecoder < BaseDecoder

  @@separator = /[\s|-]+/
  @@stric_regexp = /^(((\d\d\d)+)[\s|-]+)*((\d\d\d)+)$/

  def decode
    raise "Only codes are allowed" unless @@stric_regexp.match @message
    parts = @message.split(@@separator)

    success_messages = []
		output_str = []
    values = parts.map do |digits|
			tmp_output = []
      success_message = @wheel.ok_text || ''
      @digits.push(digits)
      codes = extract_codes(digits)
      values = @wheel.values_for(codes)
      if (values.length == @wheel_size) && (!values.include?(nil))
        values.map do |v|
          success_message = success_message.gsub "{#{v.row.label}}", v.value
          tmp_output << v.row.label + ':"' + v.value + '"'
				end
				tmp_output = tmp_output.join(", ")
      else
        raise "Code not found"
      end
			output_str << tmp_output
			if success_messages.empty?
				success_messages << success_message
			else
				if not_existe success_messages, success_message
					success_messages << success_message
				end
			end
    end
    output_str = output_str.join(' ')

    [output_str, success_messages.join(' - '), @digits]
  end

	def not_existe messages, message
		result = true
		messages.each do |msg|
			if msg == message 
				result = false
			end 			
		end
		return result
	end

end
