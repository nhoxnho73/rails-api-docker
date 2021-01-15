class MovieMailer < ApplicationMailer

  def movie_mail movie
    @user = movie.user
    mail(to: @user, subject: "welcome to movie #{movie.name}" )
  end
end
