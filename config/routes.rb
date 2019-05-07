Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "products#root"
  resources :products, only: [:index, :show, :new, :create, :edit, :update]
  resources :order_items, only: [:create, :edit, :update, :destroy]

  resources :products do
    resources :order_items, only: [:create]
  end
  resources :categories, only: [:index, :new, :create]
  resources :products do
    resources :categories, only: [:index, :create]
    resources :merchants, only: [:index]
  end

  get "categories/:id/products", to: "categories#categories", as: "categories_products"

  resources :merchants, only: [:index, :show, :create]
  resources :orders
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create", as: "auth_callback"
  delete "/logout", to: "merchants#destroy", as: "logout"

  patch "/products/:id/update_status", to: "products#update_status", as: "update_status_product"
end
