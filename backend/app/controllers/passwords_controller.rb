class PasswordsController < ApplicationController

  def create
    cre_params = create_params
    user = User.find_by_token(cre_params[:token])
    if user.nil?
      render json: {error: "No such user; check token.",
                    status: 404
                    }, status: 404
    elsif !user.authenticate(cre_params[:master_password])
      render json: {error: "Incorrect Master Password.",
                    status: 404
                    }, status: 404
    else
      AccessLog.attempt(user, "password", "create", nil)
      pass = Password.new(user_id: user.id,
                          website: cre_params[:website])
      pass.conceal(cre_params[:password], cre_params[:master_password])
      if pass.save
        AccessLog.success(user, "password", "create", pass)
        render json: {message: "Password successfully created.",
                      status: 200
                      }, status: 200
      else
        AccessLog.failure(user, "password", "create", nil)
        render json: {
                      error: "Error creating password.",
                      status: 500
                      }, status: 500
      end
    end
  end

  def get_list
    get_list_params = retrieve_all_params
    user = User.find_by_token(get_list_params[:token])
    if user.nil?
      render json: {error: "No such user; check token.",
                    status: 404
                    }, status: 404
    else
      AccessLog.attempt(user, "password", "get_list", nil)
      pass = Password.where(user_id: user.id)
      pass.each{|p| AccessLog.success(user, "password", "get_list", p) }
      render json: {websites: pass.map{|t| t.website},
                    status: 200
                    }, status: 200
    end
  end

  def get
    get_params = retrieve_params
    user = User.find_by_token(get_params[:token])
    if user.nil?
      render json: {error: "No such user; check token.",
                    status: 404
                    }, status: 404
    elsif !user.authenticate(get_params[:master_password])
      render json: {error: "Incorrect Password.",
                    status: 404
                    }, status: 404
    else
      AccessLog.attempt(user, "password", "get", nil)
      pass = Password.find_by(user_id: user.id, website: get_params[:website])
      if pass.nil?
        AccessLog.failure(user, "password", "get", pass)
        render json: {error: "No such password; check website.",
                    status: 404
                    }, status: 404
      else
        AccessLog.success(user, "password", "get", pass)
        key = pass.send_password_text()
        render json: {password: pass.send_conceal(key, get_params[:master_password]),
                      status: 200
                      }, status: 200
      end
    end
  end


  def update
    cre_params = create_params
    user = User.find_by_token(cre_params[:token])
    if user.nil?
      render json: {error: "No such user; check token.",
                    status: 404
                    }, status: 404
    elsif !user.authenticate(cre_params[:master_password])
      render json: {error: "Incorrect Master Password.",
                    status: 404
                    }, status: 404
    else
      pass = Password.find_by(user_id: user.id, website: cre_params[:website])
      if pass.nil?
        AccessLog.failure(user, "password", "destroy", nil)
        render json: {error: "No such password; check website name.",
                    status: 404
                    }, status: 404
      else
        pass.destroy
        AccessLog.attempt(user, "password", "create", nil)
        pass = Password.new(user_id: user.id,
                            website: cre_params[:website])
        pass.conceal(cre_params[:password], cre_params[:master_password])
        if pass.save
          AccessLog.success(user, "password", "create", pass)
          render json: {message: "Password successfully created.",
                        status: 200
                        }, status: 200
        else
          AccessLog.failure(user, "password", "create", nil)
          render json: {
                        error: "Error creating password.",
                        status: 500
                        }, status: 500
        end
      end
    end
  end


  def destroy
    dest_params = destroy_params
    user = User.find_by_token(dest_params[:token])
    if user.nil?
      render json: {error: "No such user; check token.",
                    status: 404
                    }, status: 404
    else
      AccessLog.attempt(user, "password", "destroy", nil)
      pass = Password.find_by(user_id: user.id, website: dest_params[:website])
      if pass.nil?
        AccessLog.failure(user, "password", "destroy", nil)
        render json: {error: "No such password; check website name.",
                    status: 404
                    }, status: 404
      else
        AccessLog.success(user, "password", "destroy", pass)
        pass.destroy
        render json: {message: "Password successfully deleted.",
                    status: 200
                    }, status: 200
      end
    end
  end

  private

  def create_params
    params.permit(:token, :website, :password, :master_password)
  end

  def retrieve_all_params
    params.permit(:token)
  end

  def retrieve_params
    params.permit(:token, :website, :master_password)
  end

  def destroy_params
    params.permit(:token, :website)
  end

end
