require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
    get signup_path
    assert_select 'form[action="/signup"]'
    assert_no_difference 'User.count' do
      post signup_path, params: {user: {name:"", email:"sthsth@sth.com",
                                       password:"sthsthsth",
                                       password_confirmation:"sthsthsth"}}
    end
    assert_template 'users/new'
  end

  test "valid signup" do
    get signup_path
    assert_difference 'User.count', 1 do
      post signup_path, params: {user: {name:"sick" , email:"sick@beat.maker",
                                         password:"whatwhat", password_confirmation:"whatwhat"}}
    end
    assert_equal 1,ActionMailer::Base.deliveries.size
    user=assigns(:user)
    assert_not user.activated?
    get edit_account_activation_path("invalid token",email:user.email)
    assert_not user.reload.activated?
    get edit_account_activation_path(user.activation_token,email:"inv email")
    assert_not is_logged_in?
    get edit_account_activation_path(user.activation_token, email:user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template "users/show"
    assert_not flash.empty?
    assert is_logged_in?
  end
end
