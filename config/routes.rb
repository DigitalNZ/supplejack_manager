HarvesterManager::Application.routes.draw do

  resources :parsers
  resources :shared_modules, except: [:show]
  resources :harvest_jobs, only: [:create, :update, :show]

  match "/parsers/:parser_id/records" => "records#index", parser_id: /[a-z0-9\-_\.]+/, as: :records

  devise_for :users

  root :to => "parsers#index"
end
