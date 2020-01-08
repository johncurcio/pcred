require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def new_email
    email = (0...20).map { (65 + rand(26)).chr }.join + "@gmail.com"
    if(User.find_by_email(email).nil?)
      return email
    else
      return new_email
    end
  end

  def new_pn
    pn = (0...10).map { ('0'..'9').to_a[rand(10)] }.join
    if(User.find_by_phone_number(pn).nil?)
      return pn
    else
      return new_pn
    end
  end

  setup do
    @user = User.new()
  end

  test "User validity tests." do
    assert_not @user.valid?
    @user.first_name = "Dave"
    assert_not @user.valid?
    @user.last_name = "Dave"
    assert_not @user.valid?
    @user.email = new_email
    assert_not @user.valid?
    @user.phone_number = new_pn
    assert_not @user.valid?
    @user.password = "password123"
    assert_not @user.valid?
    @user.password_cipher = "password_cipher"
    assert_not @user.valid?
    @user.iv = "iv"
    assert_not @user.valid?
    @user.password_confirmation = "password123"
    assert @user.valid?
    @user.password_confirmation = "password1234"
    assert_not @user.valid?

    @user.destroy

  end

end
