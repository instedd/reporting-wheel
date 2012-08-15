class NuntiumController < ApplicationController
  before_filter :authenticate
  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == Nuntium::Config['incoming_username'] && password == Nuntium::Config['incoming_password']
    end
  end

  def receive_at
    lgw = LocalGateway.where(:address => params[:to].without_protocol).first
    unless lgw
      render :text => (I18n.t :phone_not_lgw)
      return
    end

    begin
      body = params[:body]

      # TODO this hardcodes decoding of wheels to wheels of the default pool, remove when we add pool selection
      pool = Pool.first

      comb = WheelCombination.new pool, body, lgw.user
      comb.record!

      message = comb.message
    rescue RuntimeError => e
      message = I18n.t :wheel_error_message, :code => body
    end

    render :text => message, :content_type => 'text/plain'
  end
end