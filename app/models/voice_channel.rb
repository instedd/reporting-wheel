class VoiceChannel < ActiveRecord::Base
  validates_presence_of :number, :language
  validates_uniqueness_of :number
  
  def self.responses_path
    return "/wheels/all/audio"
  end
  
  def self.failure_response
    return responses_path + I18n.f("/failure.mp3")
  end
  
  def self.hello_response
    return responses_path + I18n.f("/hello.mp3")
  end
end
