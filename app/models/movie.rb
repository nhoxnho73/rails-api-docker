class Movie < ApplicationRecord
  belongs_to :user
  belongs_to :genre

  def to_builder
    Jbuilder.new do |json|
      json.extract! self, :id, :name, :director, :star, :release_date, :summary, :genre_id, :user_id
    end
  end
end