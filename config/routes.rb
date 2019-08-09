Rails.application.routes.draw do

  # Root
  root :to => "root#index"
  get 'root/index'

  devise_for :users

  # Admin
  namespace :admin do
    resources :companies
    resources :industries
    resources :countries
  end

  # Public
  resources :companies, only: [:index, :show] do
    resources :favorites, only: [:create, :destroy]
  end

end
