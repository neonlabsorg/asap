Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # resources :alerts, only: %i[index]
  # resources :sessions, only: %i[new create]
  # get "/logout", to: "sessions#destroy"
  # root "alerts#index"

  get '/login', to: 'sessions#new', as: 'login'
  post '/auth/ldap', to: 'sessions#create', as: 'new_session' # Comment when SSO!
  get '/auth/:provider/callback', to: 'sessions#create'
  post '/auth/:provider/callback', to: 'sessions#create' # remove after https://github.com/omniauth/omniauth/pull/1106
  get '/auth/failure', to: 'sessions#failure'
  post '/logout', to: 'sessions#destroy', as: 'logout'

  match "/404", via: :all, to: "errors#not_found"
  match "/500", via: :all, to: "errors#internal_server_error"

  resources :alerts, only: %i[index show update] do
    collection do
      patch :bulk_action # bulk_action_alert_path
    end
  end

  # get '/login', to: 'sessions#new', as: 'login'
  # post '/login', to: 'sessions#create', as: 'new_session'
  # post '/logout', to: 'sessions#destroy', as: 'logout'

  get '/auth/openid_connect/callback', to: 'sso_sessions#create'
  get '/auth/failure', to: 'sso_sessions#failure'

  get '/about', to: 'pages#about', as: 'about'

  namespace :api do
    namespace :v1 do
      post '/alerts', to: 'alerts#create'
      post '/arrange_alerts', to: 'alerts#arrange_alerts'
    end
  end

  root "alerts#index"
end
