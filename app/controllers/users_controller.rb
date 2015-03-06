class UsersController < ApplicationController
  layout 'login', only: :create
  def create
    @user = User.new(params.permit![:user])
    if @user.save
      flash[:notice] = "New account successfully created"
      redirect_to root_url
    else
      @user_session = UserSession.new
      @use_new_account = true
      if @user.username.blank?
        flash[:error] = 'Missing account name'
      elsif @user.password.blank?
        flash[:error] = 'Missing password'
      else
        flash[:error] = 'Password confirmation mismatch'
      end
      render 'home/index'
    end
  end

  def edit
    @user = current_user
    @local_gateway = @user.local_gateways.first
  end

  def update
    @user = current_user
    if @user.update_attributes(params.permit![:user])
      flash[:notice] = "Account successfully updated"
      redirect_to root_url
    else
      render :action => 'edit'
    end
  end

  def configure_local_gateway
    channel = current_user.register_channel params.permit![:code]
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
