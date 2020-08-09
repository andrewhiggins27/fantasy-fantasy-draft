Rails.application.routes.draw do
  root 'homes#index'
  get '/pools/:id', to: 'homes#index'
  get '/games/:id', to: 'homes#index'

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :pools, only: [:index, :update]
      resources :games, only: [:show, :update, :create]
      resources :teams, only: [:update]
    end
  end
end
