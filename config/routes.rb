Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "products#root"
  resources :products, only: [:index, :show, :new, :create, :edit, :update]

  get "/auth/github", as: "github_login"
end
