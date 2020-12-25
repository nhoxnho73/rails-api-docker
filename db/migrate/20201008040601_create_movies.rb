class CreateMovies < ActiveRecord::Migration[6.0]
  def change
    create_table :movies do |t|
      t.bigint :genre_id
      t.bigint :user_id
      t.string :name
      t.string :director
      t.string :star
      t.date :release_date
      t.string :summary

      t.timestamps
    end
  end
end
