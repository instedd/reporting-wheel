require 'guid'

class User < ActiveRecord::Base
  acts_as_authentic
  
  has_many :wheels
  has_many :local_gateways
  
  before_create :generate_submit_url_key

  def register_channel(code)
    raise Nuntium::Exception.new("There were problems creating the channel", "Ticket code" => "Mustn't be blank") if code.blank?

    unregister_channel

    new_channel_info = create_nuntium_channel_for code
    local_gateways.create! :address => new_channel_info["address"]
  end

  def unregister_channel
    lg = local_gateways.first
    if lg
      delete_nuntium_channel
      lg.destroy
    end
  end
  
  private
  
  def generate_submit_url_key
    self.submit_url_key = Guid.new.to_s
  end

  def channel_name
    "channel_for_user_id_#{id}"
  end

  def create_nuntium_channel_for(code)
    Nuntium.new_from_config.create_channel({
      :name => channel_name,
      :ticket_code => code,
      :ticket_message => "This gateway will be used for Reporting Wheel",
      :kind => 'qst_server',
      :protocol => 'sms',
      :direction => 'bidirectional',
      :configuration => { :password => SecureRandom.base64(6) },
      :enabled => true,
    })
  end

  def delete_nuntium_channel
    nuntium = Nuntium.new_from_config

    # Check that the channel exists
    nuntium.delete_channel channel_name
  end
end