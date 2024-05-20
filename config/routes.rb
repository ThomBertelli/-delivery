Rails.application.routes.draw do
  devise_for :users
  resources :stores
  get "listing" => "products#listing"

  post "new" => "registrations#create", as: :create_registration
  get "me" => "registrations#me"
  post "sign_in" => "registrations#sign_in"

  scope :buyers do
    resources :orders, only: [:index, :create, :update, :destroy]
  end


  root to: "welcome#index"
  get "up" => "rails/health#show", as: :rails_health_check
end
