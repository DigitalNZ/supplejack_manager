HarvesterManager::Application.routes.draw do

  root :to => "home#index"

  resources :parsers do
    resources :parser_versions, path: "versions", only: [:show, :update] do
      get :current, on: :collection
      get :new_enrichment, on: :member
      get :new_harvest, on: :member
    end
  end

  resources :snippets, except: [:show] do
    get "current_version", on: :collection
    resources :snippet_versions, path: "versions", only: [:show, :update] do
      get :current, on: :collection
    end
  end

  resources :parser_templates

  resources :partners, except: [:show, :destroy]
  resources :sources, except: [:destroy] do
    get :reindex, on: :member
  end

  resources :previews, only: [:show, :update]

  scope ":environment", as: "environment" do
    resources :abstract_jobs, only: [:index], path: "jobs"
    resources :harvest_jobs, only: [:create, :update, :show, :index]
    resources :enrichment_jobs, only: [:create, :update, :show, :new]
    resources :harvest_schedules
    resources :collection_statistics, only: [:index, :show]
    resources :link_check_rules
    resources :suppress_collections
    resources :collection_records, only: [:index, :update]
  end

  match "/parsers/:parser_id/preview" => "records#index", as: :preview

  devise_for :users
  resources :users, only: [:index, :edit, :update, :new, :create]
end
