class NuntiumController < ApplicationController
  before_filter :authenticate
  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == Nuntium::Config['incoming_username'] && password == Nuntium::Config['incoming_password']
    end
  end

  def recieve_at
    begin
      body = params[:body].presence || request.raw_post

      # TODO this hardcodes decoding of wheels to wheels of the default pool, remove when we add pool selection
      pool = Pool.first

      comb = WheelCombination.new pool, body
      comb.record!

      message = comb.message
    rescue RuntimeError => e
      message = I18n.t :wheel_error_message, :code => body
    end

    render :text => message
  end
end