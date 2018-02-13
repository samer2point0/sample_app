require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  def setup
    @user=users(:samer)
    @user.activation_token=User.newToken
    @user.reset_token=User.newToken
  end

  test "account_activation" do
    mail = UserMailer.account_activation(@user)
    assert_equal "Account activation", mail.subject
    assert_equal [@user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match @user.name, mail.body.encoded
    assert_match @user.activation_token, mail.body.encoded
    assert_match CGI.escape(@user.email), mail.body.encoded
  end

  test "reset_passwords" do
    mail = UserMailer.password_reset(@user)
    assert_equal "Password reset", mail.subject
    assert_equal [@user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match @user.name, mail.body.encoded
    assert_match @user.reset_token, mail.body.encoded
    assert_match CGI.escape(@user.email), mail.body.encoded
  end
end
