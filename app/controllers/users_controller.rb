class UsersController < ApplicationController
  devise_token_auth_group :member, contains: [:user]
  before_action :authenticate_member!

  def index
    @users = User.all
  end
  
end