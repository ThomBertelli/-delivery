Rails.application.routes.draw do
  devise_for :users
  resources :stores
  get "listing" => "products#listing"

  resources :stores do
    resources :products, only: [:index]
    member do
      patch :toggle_active
      patch :upload_logo
    end
  end


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

  root to: "welcome#index"
  get "up" => "rails/health#show", as: :rails_health_check
end
