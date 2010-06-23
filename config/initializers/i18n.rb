class I18n
  def f(file_path)
    file_path.reverse.sub('.', "_#{I18n.locale}.".reverse).reverse
  end
end
