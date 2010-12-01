class UsersController < ApplicationController
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "New account successfully created"
      redirect_to root_url
    else
      @user_session = UserSession.new
      render 'home/index'
    end
  end
  
end