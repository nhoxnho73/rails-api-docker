class AddMovieWorker
  require 'csv'
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(csv_file)
    CSV.foreach(csv_file, headers: true) do |movie|
      Movie.create(name: movie[0], director: movie[1], star: movie[2], release_date: movie[3], summary: movie[4], genre_id: movie[5], user_id: movie[6])
    end
  end
end