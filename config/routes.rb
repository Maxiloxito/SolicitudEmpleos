Rails.application.routes.draw do
  root 'pages#index'

  # Rutas para usuarios
  get 'register', to: 'users#new', as: 'register'
  post 'register', to: 'users#create'

  # Rutas para sesiones
  get 'login', to: 'sessions#new', as: 'login'
  post 'login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy', as: :logout

  get 'pages/index'

  get 'dashboard', to: 'dashboard#index'

  resources :job_offers, only: [:new, :create, :index, :show]
  resources :job_offers do
    resources :replacement_requests, only: [:create]
  end

  resources :employee_requests
  get 'employee_dashboard', to: 'employees#dashboard', as: 'employee_dashboard'
  get 'employer_dashboard', to: 'dashboard#employer_dashboard'
  resources :users, only: [:show, :edit, :update]
  post '/replacement_requests', to: 'replacement_requests#create', as: :replacement_requests

  resources :job_offers do
    member do
      get :applicants
    end
  end

end
