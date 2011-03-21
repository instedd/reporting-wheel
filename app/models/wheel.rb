class Wheel < ActiveRecord::Base
  
  @@max_field_code = 999
  @@url_regexp = Regexp.new('((?:http|https)(?::\\/{2}[\\w]+)(?:[\\/|\\.]?)(?:[^\\s"]*))', Regexp::IGNORECASE)
  
  has_many :wheel_rows, :dependent => :destroy, :order => "wheel_rows.index ASC"
  belongs_to :user
  belongs_to :pool
  
  attr_accessor :dont_use_cover_image_file
  attr_accessor :dont_use_success_voice_file
  attr_accessor :recalculate_factors 
  
  serialize :render_configuration, Hash
  
  validates_presence_of :name, :message => "Name can't be blank"
  validates_presence_of :factors
  validates_presence_of :user, :message => nil
  validates_presence_of :pool, :message => nil
  validates_uniqueness_of :name, :scope => :user_id, :message => "The name is already taken, please choose another name"
  
  validates_length_of :wheel_rows, :minimum => 1, :message => "At least one label is required"
  validate :uniqueness_of_factors, :factors_are_primes, :length_of_factors_and_rows, :callback_is_url
  
  accepts_nested_attributes_for :wheel_rows, :allow_destroy => true
  
  alias :rows :wheel_rows
  
  before_validation :calculate_factors
  
  before_save :save_success_voice
  before_save :save_cover_image
  
  def self.find_for_factors_and_pool(factors, pool)
    Wheel.where(:factors => factors.join(','), :pool_id => pool.id).first
  end
  
  def self.exists_for_factors_and_pool(factors, pool, except_id = nil)
    conditions = ["factors = ? AND pool_id = ?", factors.join(','), pool.id]
    
    if except_id
      conditions[0] << " AND id != ?"
      conditions << except_id
    end
    
    count = Wheel.where(conditions).count
    count > 0
  end
  
  def has_callback?
    return url_callback.present?
  end
  
  def print_config
    values = self[:render_configuration] || Hash.new
    @cfg = @cfg || PrintConfig.new(WHEEL_PRINT_CONFIG, values)
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
  
  def recalculate_factors?(rows_length)
    rows = real_rows
    # check number of rows
    return true if rows.length != rows_length.length
    # check number of values per row
    self_values_per_row = rows.map{|r| r.values.length}
    rows.length.times do |i|
      return true if rows_length[i] > self_values_per_row[i]
    end
    false
  end
  
  def values_for(codes)
    codes.map_with_index{|c,i| WheelValue.find_for(self, i, c)}
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
    
    File.open(absolute_path, "w+b") { |f| f.write(self[:cover_image].read); }
  end
  
  def absolute(path)
    "#{::Rails.root.to_s}/public#{path}"
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
    "#{images_directory}/#{name}.png"
  end
  
  def uniqueness_of_factors
    return if self.factors.nil? || self.factors.blank?
    
    factors = self.factors.split(',')
    
    if Wheel.exists_for_factors_and_pool(factors, pool, id)
      errors.add(:base, "The wheel has too many values. Please try to reduce the number of values in at least one of the labels")
    end
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
    errors.add(:url_callback, "URL Callback must be a valid URL") if @@url_regexp.match(url_callback).nil?
  end
  
  def length_of_factors_and_rows
    factors_count = self.factors.nil? ? 0 : self.factors.split(',').length
    rows_count = real_rows.length
    
    errors.add(:factors, "Length of factors is not the same as the number of wheel rows") if factors_count != rows_count
  end

  def calculate_factors
    if new_record? || recalculate_factors  
      rows_count = real_rows.map{|r| r.values.length}
      
      # check that there isnt a row with no values, otherwise we will divide by 0
      return if rows_count.min == 0
      
      factors = rows_count.map{|c| get_best_factor(c)} rescue return
      
      # TODO improve this
      while true do
        exists = Wheel.exists_for_factors_and_pool factors, pool, new_record? ? nil : self.id
        break if not exists
        maxFactor = factors.max
        factors[factors.index maxFactor] = Prime.find_first_smaller_than maxFactor rescue break
      end
      
      # save factors
      self.factors = factors.join ','
    else
      factors = self.factors.split(',').map &:to_i
    end
    
    # calculate code for each value for each row
    real_rows.each_with_index do |row, row_index|
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
  
  def real_rows
    # HACK because we use 'accepts_nested_attributes_for' for wheel_rows we need to reject manually
    # objects marked for destruction (else we will calculate factors using rows marked for deletion)
    rows.reject{|x| x.marked_for_destruction?}.sort
  end
  
end
