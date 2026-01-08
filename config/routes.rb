# config/routes.rb
require "sidekiq/web"

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"

  scope "/api" do
    resources :products, controller: "api/products"
    resource :cart, only: [:show, :create], controller: "api/carts" do
      post :add_item
    end
    delete "/cart/:id", to: "api/carts#destroy_item"
  end

  get "/demo", to: "demo#index"
  get "up" => "rails/health#show", as: :rails_health_check
  root "rails/health#show"
end
