class PasswordResetsController < ApplicationController
  before_action :valid_user, only: [:edit, :update]
  def new
  end

  def create
    @user=User.find_by(email: params[:email])
    if @user
      @user.create_reset_digest
      UserMailer.password_reset(@user).deliver_now
      flash[:info]='Email sent with password reset instructions'
      redirect_to root_url
    else
      flash.now[:danger]='Email not found!'
      render 'new'
  end

  def edit
  end

  def update
    if(params[:user][:password]).empty?
      @user.errors.add(:passwrod, "can't be empty")
      render 'edit'
    elsif @user.update_attributes(user_params)
      login @user
      flash[:success]='Password has been reset'
      redirect_to= @user
    else
      render 'edit'
    end
  end

  private
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
    def check_expiration
      if (@user.reset_sent_at < 2.hours.ago)
        flash[:warning]='Password reset has expired'
        redirect_to new_password_reset_url
      end
    end

    def valid_user
      @user=User.find_by(:email, params[:email])
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id])
        redirect_to root_url
      end
    end
end
