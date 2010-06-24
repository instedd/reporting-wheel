class Wheel < ActiveRecord::Base
  
  @@max_field_code = 999
  @@url_regexp = Regexp.new('((?:http|https)(?::\\/{2}[\\w]+)(?:[\\/|\\.]?)(?:[^\\s"]*))', Regexp::IGNORECASE)
  
  has_many :wheel_rows, :dependent => :destroy
  
  attr_accessor :dont_use_cover_image_file
  attr_accessor :dont_use_success_voice_file
  
  validates_presence_of :name, :factors
  validates_uniqueness_of :name
  
  validates_length_of :wheel_rows, :minimum => 1
  validate :uniqueness_of_factors, :factors_are_primes, :length_of_factors_and_rows, :callback_is_url
  
  accepts_nested_attributes_for :wheel_rows, :allow_destroy => true
  
  alias :rows :wheel_rows
  
  before_validation_on_create :calculate_factors
  before_validation_on_update :calculate_factors
  
  before_save :save_success_voice
  before_save :save_cover_image
  
  def self.find_for_factors(factors)
    Wheel.find :first, :conditions => {:factors => factors.join(',')}
  end
  
  def self.exists_for_factors(factors, except_id = nil)
    conditions = ["factors = ?", factors.join(',')]
    
    if except_id
      conditions[0] << " AND id != ?"
      conditions << except_id
    end
    
    count = Wheel.count :all, :conditions => conditions
    count > 0
  end
  
  def has_callback?
    return url_callback.present?
  end
  
  def success_voice_file=(value)
    self[:success_voice] = value
  end
  
  def success_voice_path
    return File.exists?(absolute(audio_path('success'))) ? audio_path('success') : nil
  end
  
  def cover_image_file=(value)
    self[:cover_image] = value
  end
  
  def cover_image_path
    return File.exists?(absolute(images_path('cover'))) ? images_path('cover') : nil
  end
  
  def absolute_cover_image_path
    absolute cover_image_path
  end
  
  private
  
  def save_success_voice
    absolute_path = absolute(audio_path('success'))
  
    if dont_use_success_voice_file == '1'
      File.delete(absolute_path) if File.exists?(absolute_path)
      return
    end
  
    return if self[:success_voice].blank?
     
    FileUtils.mkdir_p(absolute(audio_directory))
    
    File.open(absolute_path, "w") { |f| f.write(self[:success_voice].read); }
  end
  
  def save_cover_image
    absolute_path = absolute(images_path('cover'))
    
    if dont_use_cover_image_file == '1'
      File.delete(absolute_path) if File.exists?(absolute_path)
      return
    end
  
    return if self[:cover_image].blank?
     
    FileUtils.mkdir_p(absolute(images_directory))
    
    File.open(absolute_path, "w") { |f| f.write(self[:cover_image].read); }
    
    # Convert image to jpg
    begin
      img = Magick::ImageList.new absolute_path
      img.write absolute_path
    rescue => ex
      Rails.logger.warn "Couldn't transform image to JPG: #{ex}"
    end
  end
  
  def absolute(path)
    "#{RAILS_ROOT}/public#{path}"
  end
  
  def wheel_directory
    "/wheels/#{id}"
  end
  
  def audio_directory
    "#{wheel_directory}/audio" 
  end
  
  def audio_path(name)
    "#{audio_directory}/#{name}.mp3"
  end
  
  def images_directory
    "#{wheel_directory}/images" 
  end
  
  def images_path(name)
    "#{images_directory}/#{name}.jpg"
  end
  
  def uniqueness_of_factors
    return if self.factors.nil? or self.factors.blank?
    
    factors = self.factors.split(',')
    errors.add(:factors, "There is another wheel with the same factors") if Wheel.exists_for_factors(factors, id)
  end

  def factors_are_primes
    return if self.factors.nil? or self.factors.blank?
    
    factors = self.factors.split(',')
    
    factors.each do |f|
      errors.add(:factors, "#{f} is not a prime number") unless Prime.primes.include?(f.to_i)
    end
  end
  
  def callback_is_url
    return if url_callback.nil? or url_callback.empty?
    errors.add(:url_callback, "Callback must be a valid URL") if @@url_regexp.match(url_callback).nil?
  end
  
  def length_of_factors_and_rows
    factors_count = self.factors.nil? ? 0 : self.factors.split(',').length
    rows_count = self.rows.length
    
    errors.add(:factors, "Length of factors is not the same as the number of wheel rows") if factors_count != rows_count
  end

  def calculate_factors
    rows_count = rows.map{|r| r.values.length}
    
    # check that there isnt a row with no values, otherwise we will divide by 0
    return if rows_count.min == 0
    
    factors = rows_count.map{|c| get_best_factor(c)}
    
    # TODO improve this
    while true do
      exists = Wheel.exists_for_factors factors
      break if not exists
      maxFactor = factors.max
      factors[factors.index maxFactor] = Prime.find_first_smaller_than maxFactor
    end
    
    # save factors
    self.factors = factors.join(',')
    
    # calculate code for each value for each row
    rows.each_with_index do |row, row_index|
      row.index = row_index
      row.values.each_with_index do |value, value_index|
        value.index = value_index
        value.code = factors[row_index] * Prime.value_for(value_index)
      end
    end
  end
  
  def get_best_factor(count)
    ceiling = @@max_field_code / (Prime.value_for(count-1))
    Prime.find_first_smaller_than ceiling
  end
end
