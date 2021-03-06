require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  post "/graphql", to: "graphql#execute"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :posts do
        get 'find_by_title', on: :collection, to: 'posts#find_by_title'
      end
      resources :comments, only: %i[index create destroy]
      resources :rates, only: %i[create]
      resources :bookmarks, only: %i[create index]
      resources :users, only: %i[index]
    end

    namespace :admin do
      resources :posts, only: %i[destroy]
      resources :comments, only: %i[destroy]
      resources :users, only: %i[destroy]
      resources :tags, only: %i[create update destroy]
    end
  end

  mount Sidekiq::Web => '/sidekiq'

  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "graphql"
  end
end
