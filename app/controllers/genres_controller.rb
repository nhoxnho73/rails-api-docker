class GenresController < ApplicationController
  devise_token_auth_group :member, contains: [:user]
  before_action :authenticate_member!

  def index
    @genres = Genre.all
  end
end