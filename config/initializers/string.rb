class String
  # See: http://blog.grayproductions.net/articles/bytes_and_characters_in_ruby_18
  def chars_count
    self.scan(/./mu).size
  end
end
