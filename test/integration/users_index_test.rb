require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin=users(:samer)
    @other=users(:archer)
    @mallory=users(:mallory)
  end
  test "index as admin including pagination and delete" do
    login_as (@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination', count: 2
    User.paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user==@admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@other)
    end
  end
  test "index as non admin doesn't delete" do
    login_as(@other)
    get users_path
    assert_select 'a', text: 'delete', count:0
  end
end
