Rails.application.routes.draw do
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

  resources :tasks do
    resources :bids, only: [:create, :destroy]
  end

  get "my-tasks", to: "tasks#my_tasks"
end
