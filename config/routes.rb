HarvesterManager::Application.routes.draw do


  resources :parsers do
    resources :parser_versions, path: "versions", only: [:show, :update] do
      get :current, on: :collection
    end
  end

  resources :snippets, except: [:show] do
    get "search", on: :collection
  end

  resources :parser_templates

  resources :partners, except: [:show, :destroy]
  resources :sources, except: [:show, :destroy]
  
  resources :previews, only: [:show, :update]

  scope ":environment", as: "environment" do
    resources :abstract_jobs, only: [:index], path: "jobs"
    resources :harvest_jobs, only: [:create, :update, :show, :index]
    resources :enrichment_jobs, only: [:create, :update, :show]
    resources :harvest_schedules
    resources :collection_statistics, only: [:index, :show]
    resources :collection_rules
    resources :suppress_collections
  end

  match "/parsers/:parser_id/preview" => "records#index", as: :preview

  devise_for :users
  resources :users, only: [:index, :edit, :update, :new, :create]

  root :to => "parsers#index"
end