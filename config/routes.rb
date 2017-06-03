Rails.application.routes.draw do
  # get 'password_resets/new'

  # get 'password_resets/edit'

  root 'static_pages#home'
  get     '/help',     to: 'static_pages#help'
  get     '/about',    to: 'static_pages#about'
  get     '/contact',  to: 'static_pages#contact'
  get     '/signup',   to: 'users#new'
  get     '/login',    to: 'sessions#new'       #セッション8章
  post    '/login',    to: 'sessions#create'    #セッション8章
  delete  '/logout',   to: 'sessions#destroy'   #セッション8章
  
  # resources :users
  # =>/users/1 /user/2  というようなページをルーティングする
  resources :users do
      # /users/:id/following
      # /users/:id/followers
    member do
      get :following, :followers
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]
end



