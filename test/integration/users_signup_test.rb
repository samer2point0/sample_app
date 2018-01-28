require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
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
    follow_redirect!
    assert_template "users/show"
    assert_not flash.empty?
  end
end