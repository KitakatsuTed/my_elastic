require 'sidekiq/web'

Rails.application.routes.draw do
  resources :artists do
    get 'search' => 'artists#search', on: :collection
  end

  namespace :elastic do
    post 'create' => 'indices#create'
    post 'switch' => 'indices#switch_index'
    post 'import' => 'indices#import'
    post 'delete' => 'indices#destroy'
  end

  root :to => 'artists#index'

  mount Sidekiq::Web, at: "/sidekiq"
end
