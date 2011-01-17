class Wheel < ActiveRecord::Base

  DefaultRenderConfigurationWithDescriptions = [
    [:width, 'Width of the generated PDF (in cm)', 22, 0],
    [:height, 'Height of the generated PDF (in cm)', 22, 1],
    [:initial_radius, 'The radius of the biggest disc (in cm)', 10.5, 2],
    [:stroke_width, 'Stroke with to use when drawing', 2, 3],
    [:values_font_family, 'Font family to use for the values', 'Garuda', 4],
    [:values_font_size, 'Font size to use for the values', 10, 4.5],
    [:codes_font_family, 'Font family to use for the codes', 'Helvetica', 5],
    [:codes_font_size, 'Font size to use for the codes', 12, 5.5],
    [:values_width, 'Width to reserve for values on discs after the third one (in cm)', 2, 6],
    [:values_width_field_1, 'Width to reserve for values on the first (biggest) disc (in cm)', 4, 7],
    [:values_width_field_2, 'Width to reserve for values on the second disc (in cm)', 1, 8], 
    [:values_width_field_3, 'Width to reserve for values on the third (smallest) disc (in cm)', 1, 9],
    [:codes_width, 'Width to reserve for codes in any disc (in cm)', 1, 10],
    [:angle_separation, 'Angles to use when separating each value/code (in degrees)', 4, 11],
    [:angle_modifier, 'Angles to use when separating each value/code for successive wheels (it\'s added, in degress)', 2, 12],    
    [:row_separation, 'Separation from text to the next wheel disc (in cm)', 0.1, 13],
    [:field_cover_height, 'Height of the boxes in the cover to show the values/codes (in cm)', 0.8, 14],    
    [:outer_margin, 'Separation of text from disc border for the biggest disc (in cm)', 0.5, 15],
    [:inner_margin, 'Separation of text from disc border for the other discs (in cm)', 0.2, 16],
    [:alternate_colors, 'Alternate value/code colors', true, 17],
    [:new_design, 'Use new design for rows', true, 18]
  ].inject([]) {|m, o| m << {:key => o[0], :description => o[1], :value => o[2], :order => o[3]}; m }
  DefaultRenderConfiguration = DefaultRenderConfigurationWithDescriptions.inject({}) {|m, o| m[o[:key]] = o[:value]; m}
  
  @@max_field_code = 999
  @@url_regexp = Regexp.new('((?:http|https)(?::\\/{2}[\\w]+)(?:[\\/|\\.]?)(?:[^\\s"]*))', Regexp::IGNORECASE)
  
  has_many :wheel_rows, :dependent => :destroy
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
  
  before_validation_on_create :calculate_factors
  before_validation_on_update :calculate_factors
  
  before_save :save_success_voice
  before_save :save_cover_image
  
  def self.find_for_factors_and_pool(factors, pool)
    Wheel.find :first, :conditions => {:factors => factors.join(','), :pool_id => pool.id}
  end
  
  def self.exists_for_factors_and_pool(factors, pool, except_id = nil)
    conditions = ["factors = ? AND pool_id = ?", factors.join(','), pool.id]
    
    if except_id
      conditions[0] << " AND id != ?"
      conditions << except_id
    end
    
    count = Wheel.count :all, :conditions => conditions
    count > 0
  end
  
  def self.render_configuration_description(key)
    DefaultRenderConfigurationWithDescriptions.select{|x| x[:key] == key}.first[:description]
  end
  
  def self.render_configuration_order(key)
    DefaultRenderConfigurationWithDescriptions.select{|x| x[:key] == key}.first[:order]
  end
  
  def has_callback?
    return url_callback.present?
  end
  
  def render_configuration
    cfg = self[:render_configuration] || Hash.new
    cfg = cfg.symbolize_keys
    # This is to support future removal of keys/values
    cfg.each{|k, v| cfg.delete k unless DefaultRenderConfiguration.has_key? k} 
    # This is to support future additional of keys/values
    DefaultRenderConfiguration.each{|k, v| cfg[k] = cfg[k] || v}
    cfg.to_struct
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
    # check number of rows
    return true if self.rows.length != rows_length.length
    # check number of values per row
    self_values_per_row = self.rows.map{|r| r.values.length}
    self.rows.length.times do |i|
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
    
    File.open(absolute_path, "w") { |f| f.write(self[:cover_image].read); }
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
    rows_count = self.rows.length
    
    errors.add(:factors, "Length of factors is not the same as the number of wheel rows") if factors_count != rows_count
  end

  def calculate_factors
    if new_record? || recalculate_factors
      rows_count = rows.map{|r| r.values.length}
      
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
