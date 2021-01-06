class MoviesController < ApplicationController
  devise_token_auth_group :member, contains: [:user]
  before_action :authenticate_member!
  before_action :set_params, only: [:show, :update, :delete]

  def index 
    @movies = current_member.movies
  end

  def show
  end

  def create
    raise Forbidden unless current_member.is_a?(User)
    raise BadRequest, code: "genre not found" unless params[:genre_id].present?
    @movie = Movie.new 
    @movie.assign_attributes  movie_params
    @movie.user_id = current_member.id
    @movie.genre_id = params[:genre_id].to_i
    ActiveRecord::Base.transaction do
      if @movie.save
        render :show, status: :created
      else 
        raise "Error #{@movie.errors.full_messages}"
      end
    end
  end

  def update
    raise Forbidden unless current_member.is_a?(User)

    @movie.update! movie_params

    render :show
  end

  def destroy
    @movie.destroy!
    head :no_content
  end

  private
  def set_params
    @movie = current_member.movies.find_by id: params[:id]
  end

  def movie_params
    _params = params.require(:movie).permit :name, :director, :star, :release_date, :summary, :genre_id
    raise BadRequest, code: 'name is valid error' unless _params[:name].present?
    raise BadRequest, code: 'name is valid error' unless _params[:name].is_a?(String)
    raise BadRequest, code: 'director is valid error' unless _params[:director].present?
    raise BadRequest, code: 'director is valid error' unless _params[:director].is_a?(String)
    raise BadRequest, code: 'star is valid error' unless _params[:star].present?
    raise BadRequest, code: 'star is valid error' unless _params[:star].is_a?(String)

    raise BadRequest, code: 'release_date is valid error' unless _params[:release_date].present?
    raise BadRequest, code: 'release_date is valid error' unless _params[:release_date].is_a?(String)
    raise BadRequest, code: 'summary is valid error' unless _params[:summary].present?
    raise BadRequest, code: 'summary is valid error' unless _params[:summary].is_a?(String)
    _params
  end
end
