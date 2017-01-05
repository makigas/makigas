Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords'
  }
  root to: 'front#index'

  # Routes for the dashboard
  authenticate :user do
    namespace :dashboard do
      root to: 'dashboard#index', as: ''

      resources :topics
      resources :videos, only: [:index, :new, :create]
      resources :playlists do
        get :videos, on: :member
        resources :videos, except: [:index, :new, :create] do
          put :move, on: :member
        end
      end
      resources :users
    end
  end

  get :videos, to: 'videos#index'
  resources :playlists, path: 'series', only: [:index, :show] do
    resources :videos, path: '/', only: [:show]
  end
  resources :topics, only: [:index, :show]
end
