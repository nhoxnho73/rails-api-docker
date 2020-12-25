class ApplicationController < ActionController::API
  # setup return response_to json
  # include ActionController::MimeResponds
  include DeviseTokenAuth::Concerns::SetUserByToken

  # protect_from_forgery with: :exception 

end
