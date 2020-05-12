require 'sidekiq/web'

Rails.application.routes.draw do
  resources :artists

  root :to => 'artists#index'

  mount Sidekiq::Web, at: "/sidekiq"
end
