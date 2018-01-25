require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user=User.new(name: "samer", email: "samir-suraj.94@live.com",
                   password:"yoyopassword", password_confirmation:"yoyopassword")
  end
  test "should be valid" do
    assert @user.valid?
  end
  test "name should be pressent" do
    @user.name=""
    assert_not @user.valid?
  end
  test "email should be pressent" do
    @user.email=""
    assert_not @user.valid?
  end
  test "password should be present" do
    @user.password=@user.password_confirmation=" "*7
    assert_not @user.valid?
  end
  test "name should not be too long" do
    @user.name="s"*51
    assert_not @user.valid?
  end
  test "email should not be too long" do
    @user.email="s"*250+"@live.com"
    assert_not @user.valid?
  end
  test "password should be longer" do
    @user.password=@user.password_confirmation="a"*5
    assert_not @user.valid?
  end
  test "email validation should reject invalid email address" do
    emails=%w[samirsuraj@live,com samir.com samersuraj@live. samir@suraj+live.com samirsuraj@live..com]
    emails.each{ |invemail|
      @user.email=invemail
      assert_not @user.valid?, "#{invemail.inspect} should be invalid"
    }
  end
  test "email should be unique" do
    dupuser=@user.dup
    @user.save
    dupuser.email=dupuser.email.upcase
    assert_not dupuser.valid?
  end
  #how come @user isn't saved to db after prev test runs
  test "email should be downcased before save" do
    @user.email="SAMirsuraj@live.COM"
    @user.save
    assert_equal "samirsuraj@live.com", @user.reload.email
  end

end
