require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest
  def setup
    @user=users(:samer)
    @other=users(:archer)
    login_as @user
  end

  test 'following page' do
    get following_user_path(@user)
    assert_template 'users/show_follow'
    assert_not @user.following.empty?
    @user.following.each do |follower|
      assert_select 'a[href=?]', user_path(follower)
    end
  end
  test 'followers page' do
    get followers_user_path(@user)
    assert_template 'users/show_follow'
    assert_not @user.followers.empty?
    @user.followers.each do |followed|
      assert_select 'a[href=?]', user_path(followed)
    end
  end

  test 'should follow the standard way' do
    assert_difference '@user.following.count', 1 do
      post relationships_path params:{followed_id: @other.id}
    end
  end
  test 'should follow the ajax way' do
    assert_difference '@user.following.count', 1 do
      post relationships_path xhr:true, params:{followed_id: @other.id}
    end
  end
  test 'should unfollow the standard way' do
    @user.follow(@other)
    assert_difference '@user.following.count', -1 do
      delete relationship_path(@user.active_relationships.find_by(followed_id: @other.id))
    end
  end
  test 'should unfollow the ajax way' do
    @user.follow(@other)
    assert_difference '@user.following.count', -1 do
      delete relationship_path(@user.active_relationships.find_by(followed_id: @other.id)), xhr:true
    end
  end
end
