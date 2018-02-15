require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user=users(:samer)
    @micropost=@user.microposts.build(content:'lorem ipsum')
  end

  test "should be valid" do
    assert @micropost.valid?
  end

  test "user id should be present" do
    @micropost.user_id=nil
    assert_not @micropost.valid?
  end
  test "content should be present" do
    @micropost.content="   "
    assert_not @micropost.valid?
  end

  test "should be less tha 140 char" do
    @micropost.content= "A"*141
    assert_not @micropost.valid?
  end
  test "most recent should be first" do
    #assert_equal microposts(:most_recent), @user.microposts[0]
  end
end
