class UsersController < ApplicationController
  devise_token_auth_group :member, contains: [:user]
  before_action :authenticate_member!

  def show

  end
  
end