HarvesterManager::Application.routes.draw do

  resources :parsers, except: [:show], id: /[a-z0-9\-_\.]+/
  resources :shared_modules, except: [:show], id: /[a-z0-9\-_\.]+/

  match "/parsers/:parser_id/records" => "records#index", parser_id: /[a-z0-9\-_\.]+/, as: :records

  devise_for :users

  root :to => "parsers#index"
end