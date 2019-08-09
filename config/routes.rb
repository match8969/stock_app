Rails.application.routes.draw do
  get 'favorites/create'
  get 'favorites/destroy'
  # Root
  root :to => "root#index"
  get 'root/index'

  devise_for :users

  namespace :admin do
    resources :companies
    resources :industries
    resources :countries
  end
end
