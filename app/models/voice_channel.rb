class VoiceChannel < ActiveRecord::Base
  validates_presence_of :number, :language
  validates_uniqueness_of :number
end
