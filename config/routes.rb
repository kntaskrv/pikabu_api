Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html



  namespace :api do
    namespace :v1 do
      resources :posts do
        resources :comments, only: %i[index create destroy]
      end
      resources :rates, only: %i[create]
      resources :bookmarks, only: %i[create index]
    end

    namespace :admin do
      resources :posts, only: %i[destroy]
      resources :comments, only: %i[destroy]
      resources :users, only: %i[destroy]
      resources :tags, only: %i[create update destroy]
    end
  end
end
