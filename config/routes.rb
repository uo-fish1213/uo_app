Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

    # ログイン後のメインページ
  root 'prints#index'
  resources :prints, only: [:new, :create, :index, :show, :edit, :update, :destroy]
  
  #user登録のルーティング
  resources :users, only: [:new, :create]
  
  # ログイン関連
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  namespace :family do
    resource :connection, only: [:new, :create] do
        get :select, on: :collection
    end
    
    resources :codes, only: [:new, :create]
    resource :join, only: [:new, :create]
  end
  # Defines the root path route ("/")
  # root "posts#index"

end
