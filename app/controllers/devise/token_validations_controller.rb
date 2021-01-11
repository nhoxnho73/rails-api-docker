class Devise::TokenValidationsController < DeviseTokenAuth::TokenValidationsController
  def render_validate_token_success
    render json: {success: true, data: JSON.parse(@resource.to_builder.target!)}
  end
end