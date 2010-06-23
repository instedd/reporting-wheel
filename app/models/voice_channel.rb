class VoiceChannel < ActiveRecord::Base
  validates_presence_of :number, :language
  validates_uniqueness_of :number
  
  def self.responses_path
    return "/public/wheels/all/audio"
  end
  
  def self.hello_response
    return responses_path + "/hello_#{I18n.locale}.mp3"
  end
end
