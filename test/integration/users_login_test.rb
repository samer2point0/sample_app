require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user=users(:michael)
  end

  test "login with invalid information" do
    get login_path
    assert_template 'session/new'
    login_as(@user, password:'inv')
    assert_not is_logged_in?
    assert_template 'session/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information" do
    get login_path
    login_as(@user)
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)

    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_path
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count:0
    assert_select "a[href=?]", user_path(@user), count:0
  end

  test "login with remembering" do
    login_as(@user, remember_box: '1')
    assert_equal cookies['remember_token'], assigns(:user).remember_token
  end

  test "login without remembering" do
    login_as(@user, remember_box: '1')
    login_as(@user, remember_box: '0')
    assert_empty cookies['remember_token']
  end

end
