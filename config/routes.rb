HarvesterManager::Application.routes.draw do

  resources :parsers do
    resources :parser_versions, path: "versions", only: [:show, :update]
  end

  resources :shared_modules, except: [:show] do
    get "search", on: :collection
  end

  resources :harvest_jobs, only: [:create, :update, :show]

  match "/parsers/:parser_id/records" => "records#index", parser_id: /[a-z0-9\-_\.]+/, as: :records

  devise_for :users

  root :to => "parsers#index"
end
