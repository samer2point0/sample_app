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
end
