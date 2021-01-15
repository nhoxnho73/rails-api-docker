class UsersController < ApplicationController
  devise_token_auth_group :member, contains: [:user]
  before_action :authenticate_member!
  before_action :set_params, only: [:show]

  def index
    @users = User.all
  end
  
  def show

  end

  private

  def set_params
    @user = User.find_by id: params[:id]
    raise NotFound unless @user.present?
  end
end