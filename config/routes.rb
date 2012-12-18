HarvesterManager::Application.routes.draw do

  resources :parsers, except: [:show], id: /[a-z0-9\-_\.]+/

  devise_for :users

  root :to => "parsers#index"
end