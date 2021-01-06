class GenresController < ApplicationController
  devise_token_auth_group :member, contains: [:user]
  before_action :authenticate_member!
  before_action :set_params, only: [:show, :update, :delete]


  def index
    @genres = Genre.all
  end

  def create
    raise Forbidden unless current_member.is_a?(User)
    @genre = Genre.new 
    @genre.assign_attributes params_genre
    ActiveRecord::Base.transaction do
      if @genre.save
        render :show, status: :created
      else 
        raise "Error #{@genre.errors.full_messages}"
      end
    end
  end

  def update
    raise Forbidden unless current_member.is_a?(User)
    @genre.update! params_genre

    render :show
  end

  def destory
    @genre.destroy
    head :no_content
  end

  def set_params
    @genre = Genre.find params[:id]
  end
  private

  def params_genre
    _params = params.require(:genre).permit :name
    raise Badrequest, code: 'name is valid error' unless params[:name].present?
    raise Badrequest, code: 'name is valid error' unless params[:name].is_a?(String)
    _params
  end
end
