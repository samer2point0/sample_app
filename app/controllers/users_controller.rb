class UsersController < ApplicationController
  before_action :logged_in_user, only: [:destroy, :index, :edit, :update, :followers, :following]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only:[:destroy]

  def index
    @users=User.where(activated: true).paginate(page: params[:page])
  end
  def new
    @user=User.new
  end

  def create
    @user=User.new(user_params)
    if @user.save
      UserMailer.account_activation(@user).deliver_now
      flash[:success] = 'Please check your email to activate your account'
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user=User.find(params[:id])
  end

  def update
    @user=User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success]= 'Profile updated'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def show
    @user=User.find(params[:id])
    redirect_to root_url unless @user.activated?
    @microposts=@user.microposts.paginate(page: params[:page])
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:succes]="User deleted"
    redirect_to users_url
  end

  def followers
    @title='Followers'
    @user=User.find(params[:id])
    @users=@user.followers.paginate(page: params[:page])
    render  'users/show_follow' #in the users controller no need for users/show_follow
  end
  def following
    @title='Following'
    @user=User.find(params[:id])
    @users=@user.following.paginate(page: params[:page])
    render  'users/show_follow'
  end
  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def correct_user
      user=User.find(params[:id])
      unless correct_user?(user)
        redirect_to root_url
      end
    end
    def admin_user
      redirect_to root_url unless current_user.admin?
    end
end
