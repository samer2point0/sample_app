class SessionController < ApplicationController
  def new

  end

  def create
    @user= User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      login @user
      params[:session][:remember_box]=='1' ?  remember(@user) : forget(@user)
      redirect_to @user
    else
      flash.now[:danger]= "invalid email/password combination"
      render 'new'
    end
  end

  def destroy
    logout if logged_in?
    redirect_to root_path
  end
end
