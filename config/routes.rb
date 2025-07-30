Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  get "up" => "rails/health#show", as: :rails_health_check

  resources :laundromats do
    resources :orders, only: [:new, :create]
    resources :reviews, only: [:new, :create]

    resources :messages, only: [:show, :create]
  end
  resources :orders do
    resources :messages, only: [:create]
  end

  resources :orders, only: [:index, :show, :edit, :update] do
    member do
      get :confirmation
      post :confirm
      patch :cancel
    end
  end

  resources :reviews, only: [:create]
end
