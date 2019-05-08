Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "products#root"
  resources :products, only: [:index, :show, :new, :create, :edit, :update]
  resources :order_items, only: [:create, :edit, :update, :destroy]

  resources :products do
    resources :order_items, only: [:create]
  end
  resources :categories, only: [:new, :create, :index]

  resources :products do
    resources :categories, only: [:create]
  end

  get "products/:id/categories", to: "categories#select_categories", as: "product_select_categories"

  get "categories/:id/products", to: "categories#categories", as: "categories_products"
  get "merchants/:id/products", to: "merchants#merchants", as: "merchants_products"

  resources :merchants, only: [:index, :show, :create]
  resources :orders, only: [:show, :update]

  get "orders/:id/checkout", to: "orders#checkout", as: "order_checkout"
  get "orders/:id/confirmation", to: "orders#confirmation", as: "order_confirmation"

  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create", as: "auth_callback"
  delete "/logout", to: "merchants#destroy", as: "logout"

  patch "/products/:id/update_status", to: "products#update_status", as: "update_status_product"
end
