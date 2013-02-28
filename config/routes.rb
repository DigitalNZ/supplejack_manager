HarvesterManager::Application.routes.draw do

  resources :parsers do
    resources :parser_versions, path: "versions", only: [:show, :update] do
      get :current, on: :collection
    end
  end

  resources :snippets, except: [:show] do
    get "search", on: :collection
  end

  resources :harvest_jobs, only: [:index, :create, :update, :show]
  resources :harvest_schedules

  match "/parsers/:parser_id/preview" => "records#index", as: :preview

  devise_for :users

  root :to => "parsers#index"
end