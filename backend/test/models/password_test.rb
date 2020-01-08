require 'test_helper'

class PasswordTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

#  setup do
#    @user = User.new()
#    @password = Password.new()
#  end

#  test "Access logs must alter actions correctly." do

#    classes = ["user", "password", "access_log"]
#    all = ["create", "login", "destroy"].map do |t|
#          {user_id: @user.id,
#          access_class: "user",
#          action: t,
#          active_on_id: @user.id}
#    end

#    all += ["create", "get", "get_list", "destroy"].map do |t|
#           {user_id: @user.id,
#           access_class: "password",
#           action: t,
#           active_on_id: @password.id}
#    end

#    all_cases = all.map{|t| [AccessLog.attempt(t), AccessLog.success(t), AccessLog.failure(t)]}.flatten
#    
#    all_cases.each do |ca|
#      assert ca.valid?
#    end

#    @user.destroy
#    @password.destroy

#  end

end
