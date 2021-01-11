class DeviceTokensController < ApplicationController
  devise_token_auth_group :member, contains: [:user]
  before_action :authenticate_member!

  def create
    @device_token =  DeviceToken.new(device_tokens_params)
    @device_token.user_id = member_user.id

    if @device_token.save!
      render json: { status: 200 }
    else
      render json: { status: 400, message: @device_token.errors }
    end
  end

  private
  def device_tokens_params
    params.require(:device_token).permit(:user_id, :device_token)
  end

end