Rails.application.routes.draw do
  default_url_options DEFAULT_URL_OPTIONS

  root to: 'home#index'

  resources :parsers do
    get :allow_flush, on: :member
    get 'datatable', on: :collection, constraints: { format: :json }
    resources :previewers, only: [:create]
    resources :parser_versions, path: 'versions', only: [:show, :update] do
      get :current, on: :collection
      get :new_enrichment, on: :member
      get :new_harvest, on: :member
    end
  end

  scope ':environment', as: 'environment' do
    namespace :admin do
      resources :users
      resources :activities, only: [:index]
    end
  end

  resources :snippets do
    get 'current_version', on: :collection
    resources :snippet_versions, path: 'versions', only: [:show, :update] do
      get :current, on: :collection
    end
  end

  resources :parser_templates

  resources :partners, except: [:show, :destroy]
  resources :sources, except: [:destroy] do
    get :reindex, on: :member
  end

  resources :previews, only: [:show]

  scope ':environment', as: 'environment' do
    resources :abstract_jobs, only: [:index], path: 'jobs'
    resources :harvest_jobs, only: [:create, :update, :show, :index]
    resources :enrichment_jobs, only: [:create, :update, :show, :new]

    resources :harvest_schedules, except: [:show] do
      put :update_all, on: :collection
    end

    resources :collection_statistics, only: [:index, :show]
    resources :link_check_rules, except: [:show]
    resources :suppress_collections
    resources :collection_records, only: [:index, :update]
  end

  devise_for :users
  resources :users, only: [:index, :edit, :update, :new, :create]
end
