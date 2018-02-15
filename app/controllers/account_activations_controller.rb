class AccountActivationsController < ApplicationController

  def edit
    @user=User.find_by(email: params[:email])
    if @user && @user.authenticated?(:activation,params[:id])
      @user.update_columns(activated:true, activated_at:Time.zone.now)
      login @user
      flash[:success]="Account activated"
      redirect_to @user
    else
      flash[:danger]="Activation invalid!"
      redirect_to root_url
    end
  end
end
