Rails.application.routes.draw do
  mount Avo::Engine, at: Avo.configuration.root_path
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root   "tasks#index"

  post   "sign_up", to: "users#create"
  get    "sign_up", to: "users#new"

  resources :confirmations, only: [:create, :edit, :new], param: :confirmation_token

  post   "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  get    "login", to: "sessions#new"

  resources :passwords, only: [:create, :edit, :new, :update], param: :password_reset_token

  put    "account", to: "users#update"
  get    "account", to: "users#edit"
  delete "account", to: "users#destroy"

  resources :users, only: [:show], param: :username

  resources :tasks do
    resources :bids, only: [:index, :new, :create, :edit, :update, :destroy] do
      member do
        post :accept
        post :finish
      end
    end
  end

  resources :bids, only: [] do
    resources :cashouts, only: [:new, :create]
    resources :ratings, only: [:new, :create]
  end

  resources :payments, only: [:new, :create]

  resources :channels, only: [] do
    put :mark_as_read, on: :member
  end

  resources :notifications, only: [:index, :show] do
    put :mark_as_read, on: :member
  end

  resources :messages, only: [:index, :create]

  get "my-tasks", to: "tasks#my_tasks"
  get "my-bids", to: "tasks#my_bids"

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
