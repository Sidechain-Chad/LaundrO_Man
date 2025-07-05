Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check

  # Laundromats: browse, filter and show details
  resources :laundromats, only: [:index, :show] do
    # Orders: new and create under a laundromat
    resources :orders, only: [:new, :create]

    # Reviews: new and create under a laundromat
    resources :reviews, only: [:new]

    # Chats: show and create (chatroom)
    resources :chats, only: [:show, :create]
  end

  # Orders: additional actions outside nesting
  resources :orders, only: [] do
    member do
      get :confirmation
      get :order_trackings
      patch :cancel
    end
  end

  resources :reviews, only: [:create]
end
