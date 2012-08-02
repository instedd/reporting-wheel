class String
  AddressRegexp = %r(^(.*?)://(.*?)$)

  # See: http://blog.grayproductions.net/articles/bytes_and_characters_in_ruby_18
  def chars_count
    self.scan(/./mu).size
  end
  
  # Returns this string without the protocol part.
  #   'sms://foobar'.without_protocol => 'foobar'
  #   'foobar'.without_protocol => 'foobar'
  def without_protocol
    self =~ AddressRegexp ? $2 : self
  end
end
