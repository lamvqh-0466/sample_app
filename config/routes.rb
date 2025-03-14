Rails.application.routes.draw do
  get "relationships/create"
  get "relationships/destroy"
  scope "(:locale)", locale: /en|vi/ do
    get "static_pages/home"
    get "static_pages/help"

    get "/signup", to: "users#new", as: "sign_up"  
    post "/signup", to: "users#create"
    
    resources :users do
      member do
        get :following, :followers
      end
    end

    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"

    resources :account_activations, only: :edit  
    resources :password_resets, only: %i(new create edit update)
    resources :microposts, only: %i(create destroy)
    resources :relationships, only: %i(create destroy)
  end
end
