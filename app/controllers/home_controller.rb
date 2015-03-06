class HomeController < ApplicationController
  layout 'login'
  def index
    @user = User.new
    @user_session = UserSession.new
  end
end
