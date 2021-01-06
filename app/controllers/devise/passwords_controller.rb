class Devise::PasswordsController < DeviseTokenAuth::PasswordsController
  
  def render_edit_error
    render :error, status: :bad_request
  end

  def render _update_success
    render json: { success: true, data: JSON.parse(@resource.to_builder.target!) }
  end
end
