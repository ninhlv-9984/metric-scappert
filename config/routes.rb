require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  get 'home/index'
  get 'chart_data', to: 'home#chart_data'
  get 'chart_request_data', to: 'home#chart_request_data'
  get 'pods_data', to: 'home#pods_data'
  mount Sidekiq::Web => '/sidekiq'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
