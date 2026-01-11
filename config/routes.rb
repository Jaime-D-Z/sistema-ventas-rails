Rails.application.routes.draw do
  devise_for :users
  
  root 'home#index'
  
  resources :productos
  resources :ventas, only: [:index, :new, :create, :show]
  
  get 'dashboard', to: 'home#dashboard'
end