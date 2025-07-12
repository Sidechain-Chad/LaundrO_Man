Rails.application.routes.draw do
  get 'orders/index'
  get 'orders/show'
  get 'orders/new'
  get 'orders/create'
  get 'orders/confirmation'
  get 'orders/cancel'
  get 'orders/order_trackings'
  get 'reviews/new'
  devise_for :users
  root to: "pages#home"

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check

  # Laundromats: browse, filter and show details
  resources :laundromats do
    # Orders: new and create under a laundromat
    resources :orders, only: [:new, :create]

    # Reviews: new and create under a laundromat
    resources :reviews, only: [:new, :create]

    # Chats: show and create (chatroom)
    resources :chats, only: [:show, :create]
  end

  # Orders: additional actions outside nesting
  resources :orders, only: [:index, :show] do
    member do
      get :confirmation
      get :order_trackings
      patch :cancel
    end
  end

  resources :reviews, only: [:create]
end
