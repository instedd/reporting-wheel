class Hash
  # keys should be symbolized (try symbolize_keys before executing it) before using it.
  def to_struct
    Struct.new(*keys).new(*values)
  end
end

class Struct
  def to_a
    a = []
    self.each_pair {|name, value| a << [name,value] }
    a
  end
end