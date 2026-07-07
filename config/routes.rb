Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  # ログイン後のメインページ
  root 'prints#index'
  resources :prints, only: [:new, :create, :index, :show, :edit, :update, :destroy]
  
  # user登録のルーティング
  resources :users, only: [:new, :create]
  
  # ログイン関連
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  # 家族連携機能
  namespace :family do
    # 家族連携の選択画面
    get 'connections/select', to: 'connections#select', as: :connection_select
    
    # 家族コード発行
    resources :connections, only: [:new, :create] do
       get :select, on: :collection
    end

    # 既存コードで参加
    resource :join, only: [:new, :create]
  end
end