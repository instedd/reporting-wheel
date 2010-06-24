
module I18n
  def self.f(file_path)
    file_path.reverse.sub('.', "_#{locale}.".reverse).reverse
  end
end
