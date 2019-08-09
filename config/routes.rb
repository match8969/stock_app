Rails.application.routes.draw do

  get 'holdings/create'
  get 'holdings/destroy'
  # Root
  root :to => "root#index"
  get 'root/index'

  devise_for :users

  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  # Admin
  namespace :admin do
    resources :companies
    resources :industries
    resources :countries
  end

  # Public
  resources :companies, only: [:index, :show] do
    resources :favorites, only: [:create, :destroy]
    resources :holdings, only: [:create, :destroy]
  end

  # Development
  if Rails.env.development?
    # Confirmation Mail
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
  end

end
