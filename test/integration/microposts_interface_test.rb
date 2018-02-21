require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user=users(:samer)
    @archer=users(:archer)
  end

  test 'microposts interface' do
    login_as @user
    get root_url
    assert_select 'div.pagination'
    #failing post
    assert_no_difference 'Micropost.count' do
      post microposts_path, params:{micropost:{content: ''}}
    end
    #successful post
    content= 'this should work'
    assert_difference 'Micropost.count',1 do
      post microposts_path, params:{micropost:{content: content}}
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    #successful delete
    assert_select 'a', text: 'delete'
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(@user.microposts.first)
    end

    get user_path(@archer)
    assert_select 'a', text: 'delete', count:0

  end
end
