require 'test_helper'

class AccessLogTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

#  def new_email
#    email = (0...20).map { (65 + rand(26)).chr }.join + "@gmail.com"
#    if(User.find_by_email(email).nil?)
#      return email
#    else
#      return new_email
#    end
#  end

#  def new_pn
#    pn = (0...10).map { ('0'..'9').to_a[rand(10)] }.join
#    if(User.find_by_phone_number(pn).nil?)
#      return pn
#    else
#      return new_pn
#    end
#  end

  setup do
    @user = User.new()
    @password = Password.new()
  end

  test "Access logs must alter actions correctly." do
    
      puts @user.inspect

    classes = ["user", "password", "access_log"]
    all = ["create", "login", "destroy"].map do |t|
          {user_id: @user.id,
          access_class: "user",
          action: t,
          active_on_id: @user.id}
    end

    all += ["create", "get", "get_list", "destroy"].map do |t|
           {user_id: @user.id,
           access_class: "password",
           action: t,
           active_on_id: @password.id}
    end

    all_cases = all.map{|t| [AccessLog.attempt(t[:user_id], t[:access_class], t[:action], t[:active_on_id]),
                              AccessLog.success(t[:user_id], t[:access_class], t[:action], t[:active_on_id]),
                              AccessLog.failure(t[:user_id], t[:access_class], t[:action], t[:active_on_id])]}.flatten
    
    all_cases.each do |ca|
      assert ca.valid?
    end

    @user.destroy
    @password.destroy

  end

end
