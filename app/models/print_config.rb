class PrintConfig
  
  def initialize(definition, values)
    @definition = definition
    @values = values
    @values.each{|k,v| values.delete k unless keys.include? k}
  end
  
  def keys
    @definition.keys
  end
  
  def ordered_keys
    keys.sort{|a,b| @definition[a]['order'] <=> @definition[b]['order']}
  end
  
  def [](key)
    val = @values[key] || @definition[key]['default']
    cast val, type(key)
  end
  
  def []=(key, value)
    @values[key] = value
  end
  
  def desc(key)
    @definition[key]['desc']
  end
  
  def default(key)
    @definition[key]['default']
  end
  
  def type(key)
    @definition[key]['type']
  end
  
  private
  
  def cast(value, type)
    case type
      when :numeric
        value.to_f
      when :string
        value.to_s
      when :boolean
        value.to_s == "true"
      else
        value.to_s
    end
  end
end