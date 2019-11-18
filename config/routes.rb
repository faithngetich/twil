Rails.application.routes.draw do
  get 'sessions/create'
  resources :passwords, controller: "clearance/passwords", only: [:create, :new]
  resource :session, controller: "sessions", only: [:create]

  resources :users, controller: "clearance/users", only: [:create] do
    resource :password,
      controller: "clearance/passwords",
      only: [:create, :edit, :update]
  end

  get "/sign_in" => "clearance/sessions#new", as: "sign_in"
  delete "/session" => "clearance/sessions#destroy", as: "sign_out"
  # delete '/sign_out' => 'clearance/sessions#destroy', as: 'sign_out'
  get "/sign_up" => "users#new", as: "sign_up"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "home#index"

  # Authy
  post "authy/callback" => 'authy#callback'
  get "authy/status" => 'authy#one_touch_status'
end
