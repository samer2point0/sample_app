require 'test_helper'

class RelationshipsControllerTest < ActionDispatch::IntegrationTest

  test 'following should be only for logged in' do
    assert_not_difference 'Relationships.count' do
      post relationships_path
    end
    assert_redirected_to login_url
  end
  test 'unfollowing should be only for logged in' do
    assert_not_difference 'Relationships.count' do
      delete relationships_path(relationships(:one))
    end
    assert_redirected_to login_url
  end
end
