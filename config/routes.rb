HarvesterManager::Application.routes.draw do

  resources :parsers, except: :show

  devise_for :users

  root :to => "parsers#index"
end