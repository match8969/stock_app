Rails.application.routes.draw do

  # Root
  root :to => "root#index"
  get 'root/index'

  devise_for :users

  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  # Admin  --------------------
  namespace :admin do
    resources :companies
    resources :industries
    resources :countries
    resources :markets
    resources :financial_reports
    resources :stocks, only: [:create, :edit, :update, :destroy]

    # special
    get 'companies/update_report/:id' => 'companies#update_financial_report', as: :companies_update_report
  end

  # Public --------------------

  # Company
  resources :companies, only: [:index, :show] do
    resources :favorites, only: [:create, :destroy]
    resources :holdings, only: [:create, :destroy]
  end

  # About
  # as は xxx_pathとして使用する
  get 'about' => 'abouts#about', as: :about
  get 'term' => 'abouts#term', as: :term
  get 'privacy' => 'abouts#privacy', as: :privacy

  # Development
  if Rails.env.development?
    # Confirmation Mail
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
  end

end
