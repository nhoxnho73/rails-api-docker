Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    passwords: 'devise/passwords',
    registrations: 'devise/user_registrations',
    sessions: 'devise/sessions',
    token_validations: 'devise/token_validations',
  }

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :users
  resources :movies
  resources :genres
  
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  # mount ActionCable.server => '/cable' #kich hoat actioncable
end
