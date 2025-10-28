require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"
  resources :products
  resource :cart, only: [:show, :create], controller: "carts" do
    post :add_item, to: "carts#add_item"
  end

  get    "/cart",           to: "carts#show"
  post   "/cart",           to: "carts#create"
  post   "/cart/add_item",  to: "carts#add_item"
  delete "/cart/:id", to: "carts#destroy_item", as: :cart_remove_item
  
  get "up" => "rails/health#show", as: :rails_health_check
  root "rails/health#show"
end
