require 'test_helper'

class PasswordsControllerTest < ActionController::TestCase

=begin
  def new_id
    id = rand(10000000)
    if(User.find(id).nil?)
      return id
    else
      return new_id
    end
  end

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
    @user = User.new
    @user.save()
  end


  test "Create Tests" do
    @user.update(token: "hashfaklhhfal2hl8hl28ad2hd823r7a2d7il237r7237l3223di7i723lh7i2", token_expires: (Time.now + 24*3600*7).to_time) 
    post(:create, {token: @user.token,
                    website: "www.website.com",
                    password: "password123"})
    assert_response :success

    post(:create, {token: @user.token,
                    website: "www.website.com",
                    password: "password13"})
    assert_response :error
  end

  
  test "Get List Tests" do
    @user.update(token: "hashfaklhhfal2hl8hl28ad2hd823r7a2d7il237r7237l3223di7i723lh7i2", token_expires: (Time.now + 24*3600*7).to_time) 
    post(:create, {token: @user.token,
                    website: "www.website.com",
                    password: "password123"})

    post(:create, {token: @user.token,
                    website: "www.website2.com",
                    password: "password123"})

    post(:get_list, {token: @user.token})
    assert_response :success

    post(:get_list, {token: @user.token+"asdfasdfa"})
    assert_response :missing
  end

  
  test "Get Tests" do
    @user.update(token: "hashfaklhhfal2hl8hl28ad2hd823r7a2d7il237r7237l3223di7i723lh7i2", token_expires: (Time.now + 24*3600*7).to_time) 
    post(:create, {token: @user.token,
                    website: "www.website.com",
                    password: "password123"})

    post(:create, {token: @user.token,
                    website: "www.website2.com",
                    password: "password123"})

    post(:get, {token: @user.token,
                      website: "www.website.com"})
    assert_response :success

    post(:get, {token: @user.token+"asdfasdfa"})
    assert_response :missing

    post(:get, {token: @user.token,
                      website: "www.website.com2"})
    assert_response :missing
  end

  
  test "Destroy Tests" do
    @user.update(token: "hashfaklhhfal2hl8hl28ad2hd823r7a2d7il237r7237l3223di7i723lh7i2", token_expires: (Time.now + 24*3600*7).to_time) 
    post(:create, {token: @user.token,
                    website: "www.website.com",
                    password: "password123"})

    post(:destroy, {token: @user.token,
                      website: "www.website.com"})
    assert_response :success

    post(:destroy, {token: @user.token+"asdfasdfa",
                      website: "www.website.com"})
    assert_response :missing

    post(:destroy, {token: @user.token,
                      website: "www.website.com"})
    assert_response :missing
  end

=end

end
