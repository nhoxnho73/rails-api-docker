class Devise::UserRegistrationsController < DeviseTokenAuth::RegistrationsController

  def render_create_success
    render json: {status: 'success', data: JSON.parse(@resource.to_builder.target!)}, status: :created
  end

  private 
    def sign_up_params
            
      @_params ||= begin
        _params = params.permit :email, :username, :password
        
        raise BadRequest, code: 'user_blank_email_error' unless _params[:email].present?
        raise BadRequest, code: 'user_invalid_email_error' unless _params[:email].is_a?(String)
        raise BadRequest, code: 'user_blank_username_error' unless _params[:username].present?
        raise BadRequest, code: 'user_invalid_username_error' unless _params[:username].is_a?(String)
        raise BadRequest, code: 'user_too_short_username_error' unless _params[:username].size >= User::USERNAME_MIN_SIZE
        raise BadRequest, code: 'user_too_long_username_error' unless _params[:username].size <= User::USERNAME_MAX_SIZE
        raise BadRequest, code: 'user_blank_password_error' unless _params[:password].present?
        raise BadRequest, code: 'user_invalid_password_error' unless _params[:password].is_a?(String)
        raise BadRequest, code: 'user_too_short_password_error' unless _params[:password].size >= User::PASSWORD_MIN_SIZE
        raise BadRequest, code: 'user_too_long_password_error' unless _params[:password].size <= User::PASSWORD_MAX_SIZE
        _params
      end
    end
end
