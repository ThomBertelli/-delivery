Rails.application.routes.draw do
  devise_for :users

  resources :order_items

  resources :stores do
    resources :products, only: [:index]
    get "/orders/new" => "stores#new_order"
    member do
      patch :toggle_active
      patch :upload_logo

    end
  end

  get "listing" => "products#listing"

  post "new" => "registrations#create", as: :create_registration
  get "me" => "registrations#me"
  post "sign_in" => "registrations#sign_in"

  scope :buyers do
    resources :orders, only: [:index, :create, :update, :destroy]
  end

  resources :products do
    member do
      patch :toggle_active
      patch :upload_image
    end
  end

  resources :orders do
    get "/watch" => "orders#order_watch"
    member do
      patch :update_state
      post 'pay'
    end
  end

  root to: "welcome#index"
  get "up" => "rails/health#show", as: :rails_health_check
end
