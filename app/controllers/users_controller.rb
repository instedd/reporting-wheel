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
    @local_gateway = @user.local_gateways.first
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

  def configure_local_gateway
    channel = current_user.register_channel params[:code]
    render :json => {'success' => true, 'address' => channel.address}
  rescue Exception => ex
    render :json => {'success' => false}
  end

  def unregister_local_gateway
    current_user.unregister_channel
    render :json => :ok
  rescue Exception => ex
    render :json => :bad
  end
end