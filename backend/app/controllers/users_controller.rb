class UsersController < ApplicationController
  def create
    if params[:answer_1].nil? || params[:answer_2].nil? || params[:answer_3].nil?
      AccessLog.failure(user, "user", "create", user)
        render json: {error: "Invalid Answers.", status: 500}, status: 500
    else
      pars = create_params.merge(User.password_auth(params[:answer_1], params[:answer_2], params[:answer_3], create_params[:password]))
      user = User.new(pars)
      user[:token] = user.token_gen
      user[:token_expires] = (Time.now + 24*3600*7).to_time

      AccessLog.attempt(user, "user", "create", user)
      if user.valid? && user.save
        AccessLog.success(user, "user", "create", user)
        render json: {user: user.with_token, status: 200}, status: 200
      else
        AccessLog.failure(user, "user", "create", user)
        render json: {error: "Invalid User Attributes.",
                      status: 500
                      }, status: 500
      end
    end
  end

  def login
    log_params = login_params
    user = User.find_by_email(log_params[:email].downcase)
    AccessLog.attempt(user, "user", "login", user)
    if !user.nil? && user.authenticate(log_params[:password])
      AccessLog.success(user, "user", "login", user)
      user.token_check
      render json: {token: user.token,
                    user: { first_name: user.first_name, last_name: user.last_name },
                    status: 200}, status: 200
    else
      AccessLog.failure(user, "user", "login", user)
      render json: {error: "Invalid Email Or Password", status: 404}, status: 404
    end
  end

  def destroy
    log_params = login_params
    user = User.find_by_email(log_params[:email])
    AccessLog.attempt(user, "user", "destroy", user)
    AccessLog.failure(user, "user", "destroy", user)
    render json: {error: "Cannot Destroy User", status: 404}, status: 404
  end

  def update
    up_params = update_params
    user = User.find_by_token(up_params[:token])
    AccessLog.attempt(user, "user", "update", user)
    unless user.nil?
      if params[:password]
        if user.authenticate(up_params[:old_password])
          if user.update(first_name: up_params[:first_name] || user.first_name,
                          last_name: up_params[:last_name] || user.last_name,
                          email: user.email,
                          phone_number: user.phone_number,
                          password: up_params[:password],
                          password_confirmation: up_params[:password_confirmation])

            user.password_swap(up_params[:old_password], up_params[:password])
            up_success(user)
          else
            puts user.inspect
            up_failure(user, "Unable to update user.")
          end
        else
          up_failure(user, "Invalid Old Password")
        end
      else
        user.update(first_name: up_params[:first_name] || user.first_name,
                    last_name: up_params[:last_name] || user.last_name,
                    email: user.email,
                    phone_number: user.phone_number)
        up_success(user)
      end
    else
      up_failure(user, "Invalid Token. No Such User")
    end
  end

  def recover_password
    begin
      pr_params = password_recovery_params
      user = User.find_by_email(pr_params[:email])
      if user.nil?
        AccessLog.failure(user, "user", "recover", user)
        render json: {error: "No User With Given Email.", status: 404}, status: 404
      elsif params[:answer_1].nil? || params[:answer_2].nil? || params[:answer_3].nil?
        AccessLog.failure(user, "user", "recover", user)
        render json: {error: "Answers May Not Be Null.", status: 404}, status: 404
      else
        password = user.recover_password(params[:answer_1], params[:answer_2], params[:answer_3])
        AccessLog.success(user, "user", "recover", user)
        render json: {password: password, status: 200}, status: 200
      end
    rescue
        AccessLog.failure(user, "user", "recover", user)
        render json: {error: "Incorrect Keys.", status: 404}, status: 404      
    end
  end


  def up_success(user)
    AccessLog.success(user, "user", "update", user)
    render json: {message: "User successfully updated.", status: 200}, status: 200
  end


  def up_failure(user, error)
    AccessLog.failure(user, "user", "update", user)
    render json: {error: error, status: 404}, status: 404
  end

  private

  def create_params
    params.permit(:first_name, :last_name, :email, :phone_number, :password, :password_confirmation)
  end

  def login_params
    params.permit(:email, :password)
  end

  def update_params
    params.permit(:token, :first_name, :last_name, :password, :password_confirmation, :old_password)
  end

  def destroy_params
    params.permit(:email, :password, :password_confirmation)
  end

  def password_recovery_params
    params.permit(:email, :question_1, :question_2, :question_3)
  end
end
