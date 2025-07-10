Rails.application.routes.draw do
  # Devise authentication
  devise_for :users

  # Home page
  root to: "pages#home"

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Laundromats: browse, filter and show details
  resources :laundromats, only: [:index, :show] do
    # Nested orders: for booking a laundromat
    resources :orders, only: [:new, :create]

    # Nested reviews: new review under laundromat
    resources :reviews, only: [:new]

    # Chats between user and laundromat
    resources :messages, only: [:show, :create]
  end

  # Orders: outside nesting for confirmation, tracking, cancel, etc.
  resources :orders, only: [:index, :show] do
    member do
      get :confirmation
      get :tracking  # was :order_trackings, renamed for clarity
      patch :cancel
      patch :confirm
    end
  end


  # Reviews create action outside nesting
  resources :reviews, only: [:create]
end
