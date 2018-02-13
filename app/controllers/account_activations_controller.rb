class AccountActivationsController < ApplicationController

  def edit
    @user=User.find_by(email: params[:email])
    if @user && @user.authenticated?(:activation,params[:id])
      @user.update_attribute(:activated, true)
      @user.update_attribute(:activated_at, Time.zone.now)
      login @user
      flash[:succes]="Account activated"
      redirect_to @user
    else
      flash[:dange]="Activation invalid!"
      redirect_to root_url
    end
  end
end
