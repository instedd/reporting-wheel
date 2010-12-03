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
  
  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account successfully updated"
      redirect_to root_url
    else
      render :action => 'edit'
    end
  end
  
end