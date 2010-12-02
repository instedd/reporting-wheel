module ErrorsHelper
    def error_messages_for(*params)
      options = params.extract_options!.symbolize_keys
      
      exclude = options[:exclude] || []
      show_fields = options[:show_fields].nil? ? true : options[:show_fields]

      if object = options.delete(:object)
        objects = Array.wrap(object)
      else
        objects = params.collect {|object_name| instance_variable_get("@#{object_name}") }.compact
      end

      count  = objects.inject(0) {|sum, object| sum + object.errors.count }
      unless count.zero?
        html = {}
        [:id, :class].each do |key|
          if options.include?(key)
            value = options[key]
            html[key] = value unless value.blank?
          else
            html[key] = 'errorExplanation'
          end
        end
        options[:object_name] ||= params.first

        I18n.with_options :locale => options[:locale], :scope => [:activerecord, :errors, :template] do |locale|
          header_message = if options.include?(:header_message)
            options[:header_message]
          else
            object_name = options[:object_name].to_s
            object_name = I18n.t(object_name, :default => object_name.gsub('_', ' '), :scope => [:activerecord, :models], :count => 1)
            locale.t :header, :count => count, :model => object_name
          end
          
          message = options.include?(:message) ? options[:message] : locale.t(:body)
          
          if show_fields
            error_messages = objects.sum {|object| object.errors.full_messages.map {|msg| content_tag(:li, ERB::Util.html_escape(msg)) } }.join.html_safe
          else
            error_messages = objects.sum {|object| error_messages(object.errors,exclude).map {|msg| content_tag(:li, ERB::Util.html_escape(msg)) }}.join.html_safe
          end
          
          contents = ''
          contents << content_tag(options[:header_tag] || :h2, header_message) unless header_message.blank?
          contents << content_tag(:p, message) unless message.blank?
          contents << content_tag(:ul, error_messages)

          content_tag(:div, contents.html_safe, html)
        end
      else
        ''
      end
    end
    
    private
    
    def error_messages(errors, exclude)
      error_messages = []

      errors.each do |attr, error|
        next if exclude.include?(attr)
        errors[attr].each do |msg|
          next if msg.nil?
          
          error_messages << msg
        end
      end
      error_messages
    end
end