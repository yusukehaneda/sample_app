Rails.application.routes.draw do
  root 'static_pages#home'
  get     '/help',     to: 'static_pages#help'
  get     '/about',    to: 'static_pages#about'
  get     '/contact',  to: 'static_pages#contact'
  get     '/signup',   to: 'users#new'
  get     '/login',    to: 'sessions#new'       #セッション8章
  post    '/login',    to: 'sessions#create'    #セッション8章
  delete  '/logout',   to: 'sessions#destroy'   #セッション8章
  resources :users
  # =>/users/1 /user/2  というようなページをルーティングする
  resources :microposts,          only: [:create, :destroy]
end



