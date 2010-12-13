class UserSessionsController < ApplicationController
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Successfully logged in"
      redirect_to root_url
    else
      @user = User.new
      render 'home/index'
    end
  end

  def destroy
    @user_session = UserSession.find
    if @user_session
      @user_session.destroy
      flash[:notice] = "Successfully logged out"
    end
    redirect_to home_url
  end

end