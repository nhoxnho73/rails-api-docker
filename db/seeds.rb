# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'

CSV.read('seed_files/genre.csv').each do |row|
  Genre.find_or_create_by! name: row[0]
end

# CSV.read('seed_files/movie.csv').each do |row|
#   Movie.find_or_create_by! genre_id: row[0], user_id: row[1], name: row[2], director: row[3], star: row[4], release_date: [5], summary: [6]
# end