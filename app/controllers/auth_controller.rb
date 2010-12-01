class AuthController < ApplicationController
  before_filter :login_required
  
  protected
  
  def permission_denied
    redirect_to home_url
  end
end
