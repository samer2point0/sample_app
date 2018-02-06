require 'test_helper'
class SessionHelperTest < ActionView::TestCase
  def setup
    @user=users(:michael)
    remember(@user)
  end

  test "current_user returns right user when no session" do
    assert_equal current_user, @user
    assert is_logged_in?
  end

  test "current user returns nill when authenticated? fails" do
    @user.update_attribute(:remember_digest, User.digest(User.newToken))
    assert_nil current_user
  end

end
