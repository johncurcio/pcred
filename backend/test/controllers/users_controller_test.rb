require 'test_helper'

class UsersControllerTest < ActionController::TestCase

=begin
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

  def setup
    @email = new_email
    @phone_number = new_pn
    @login_email = new_email
    @login_phone_number = new_pn
  end


  test "Create Tests" do
    post(:create, {first_name: "Dave",
                    last_name: "Johnson",
                    email: @email,
                    phone_number: @phone_number,
                    password: "password123",
                    password_confirmation: "password123"})
    assert_response :success

  #test "should fail to create duplicate email" do
    post(:create, {first_name: "Dave",
                    last_name: "Johnson",
                    email: new_email,
                    phone_number: @phone_number,
                    password: "password123",
                    password_confirmation: "password123"})
    assert_response :error

  #test "should fail to create duplicate phone_number" do
    post(:create, {first_name: "Dave",
                    last_name: "Johnson",
                    email: @email,
                    phone_number: new_pn,
                    password: "password123",
                    password_confirmation: "password123"})
    assert_response :error

  #test "should fail to create duplicate email and phone_number" do
    post(:create, {first_name: "Dave",
                    last_name: "Johnson",
                    email: @email,
                    phone_number: @phone_number,
                    password: "password123",
                    password_confirmation: "password123"})
    assert_response :error

  #test "should succeed with duplicate other attributes" do
    post(:create, {first_name: "Dave",
                    last_name: "Johnson",
                    email: new_email,
                    phone_number: new_pn,
                    password: "password123",
                    password_confirmation: "password123"})
    assert_response :success
  end


  test "Login Tests" do
    post(:create, {first_name: "Dave",
                    last_name: "Johnson",
                    email: @login_email,
                    phone_number: @login_phone_number,
                    password: "password123",
                    password_confirmation: "password123"})
    assert_response :success

  #test "should succeed at logging in" do
    post(:login, {email: @login_email,
                    password: "password123"})
    assert_response :success

  #test "should fail to login with wrong password" do
    post(:login, {email: new_email,
                    password: "password123"})
    assert_response :missing

  #test "should fail to login with wrong password" do
    post(:login, {email: @login_email,
                    password: "password1234"})
    assert_response :missing
  end

  test "Destroy Tests" do
    post(:create, {first_name: "Dave",
                    last_name: "Johnson",
                    email: @login_email,
                    phone_number: @login_phone_number,
                    password: "password123",
                    password_confirmation: "password123"})
    assert_response :success
  #test "should fail to destroy user" do
    post(:destroy, {email: @login_email,
                    password: "password123"})
    assert_response :missing
  #test "should fail to destroy user" do
    post(:destroy, {token: User.new.token_gen})
    assert_response :missing
  end

#  test "should get login" do
#    get :login
#    assert_response :success
#  end

#  test "should get destroy" do
#    get :destroy
#    assert_response :success
#  end
=end
end
