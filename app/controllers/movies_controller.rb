class MoviesController < ApplicationController
  devise_token_auth_group :member, contains: [:user]
  before_action :authenticate_member!
  before_action :set_params, only: [:show, :update, :delete]

  def index 
    # binding.pry
    @movies = current_member.movies
  end

  def show
    # binding.pry
  end

  def create
    binding.pry
    raise "user not found" unless current_member.is_a?(User)

    @movie = Movie.new(movie_params)
    @movie.user_id = current_member.id
    if @movie.save
      render :show, status: :created
    else 
      raise "Error #{@movie.errors.full_messages}"
    end
  end

  def update
    raise 'user not found' unless current_member.is_a?(User)

    @movie.update! movie_params

    render :show
  end

  def destroy
    @movie.destroy!
    head :no_content
  end

  private
  def set_params
    @movie = current_member.movies.find_by(id: params[:id])
  end

  def movie_params
    params.permit(:name, :director, :star, :release_date, :summary, :user_id, :genre_id)
    raise 'name is valid error' unless params[:name].present?
    raise 'name is valid error' unless params[:name].is_a?(String)
    raise 'director is valid error' unless params[:director].present?
    raise 'director is valid error' unless params[:director].is_a?(String)
    raise 'star is valid error' unless params[:star].present?
    raise 'star is valid error' unless params[:star].is_a?(String)

    raise 'release_date is valid error' unless params[:release_date].present?
    raise 'release_date is valid error' unless params[:release_date].is_a?(String)
    raise 'summary is valid error' unless params[:summary].present?
    raise 'summary is valid error' unless params[:summary].is_a?(String)
  end
end
