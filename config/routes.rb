HarvesterManager::Application.routes.draw do

  resources :parsers, except: [:show], id: /[a-z0-9\-_\.]+/
  resources :shared_modules, except: [:show], id: /[a-z0-9\-_\.]+/
  resources :harvest_jobs, only: [:create, :show]

  match "/parsers/:parser_id/records" => "records#index", parser_id: /[a-z0-9\-_\.]+/, as: :records
  match "/parsers/:parser_id/harvest" => "records#harvest", parser_id: /[a-z0-9\-_\.]+/, as: :harvest

  devise_for :users

  root :to => "parsers#index"

  # sidekiq interface, using device for authentication
  require 'sidekiq/web'
  constraint = lambda { |request| request.env['warden'].authenticate!({ scope: :user }) }
  constraints constraint do
    mount Sidekiq::Web => '/sidekiq'
  end
end
