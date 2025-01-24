Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
    get '/menu', to: 'menu#index'
    patch '/inventory', to: 'inventory#update'

    resources :pizzas, only: [:index, :create, :show]
      resources :orders do
    member do
      patch :update_status
      patch :confirm
    end
  end
end
