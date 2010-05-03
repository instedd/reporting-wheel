class Prime
  @@primes = [17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73,
		79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 
		167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 227, 229, 233, 239, 241, 251, 
		257, 263, 269, 271, 277, 281, 283, 293, 307, 311, 313, 317, 331, 337, 347, 349, 
		353, 359, 367, 373, 379, 383, 389, 397, 401, 409, 419, 421, 431, 433, 439, 443, 
		449, 457, 461, 463, 467, 479, 487, 491, 499]

	@@values = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 18, 20, 21, 22, 24, 
    25, 26, 27, 28, 30, 32, 33, 35, 36, 39, 40, 42, 44, 45, 48, 49, 50, 52, 54, 
  	55, 56, 60, 63, 64, 65, 66, 70, 72, 75]
  
  def self.primes
    @@primes
  end
  
  def self.value_for(index)
    @@values[index]
  end
  
  # TODO improve this	
  def self.find_first_smaller_than(n)
    last = 0
    
    @@primes.each do |p|
      if p < n:
        last = p
      else
        break
      end
    end
    
    last
  end
  
  def self.factorize(n)
    @@primes.each do |p|
      return p if n % p == 0
    end
    n #return n if no prime is found
  end
  
end