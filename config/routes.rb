# The majority of The Supplejack Manager code is Crown copyright (C) 2014, New Zealand Government,
# and is licensed under the GNU General Public License, version 3. Some components are 
# third party components that are licensed under the MIT license or otherwise publicly available. 
# See https://github.com/DigitalNZ/supplejack_manager for details. 
# 
# Supplejack was created by DigitalNZ at the National Library of NZ and the Department of Internal Affairs. 
# http://digitalnz.org/supplejack

HarvesterManager::Application.routes.draw do

  root to: 'home#index'

  resources :parsers do
    get :allow_flush, on: :member
    resources :previewers, only: [:create]
    resources :parser_versions, path: 'versions', only: [:show, :update] do
      get :current, on: :collection
      get :new_enrichment, on: :member
      get :new_harvest, on: :member
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

  resources :previews, only: [:show, :update]

  scope ':environment', as: 'environment' do
    resources :abstract_jobs, only: [:index], path: 'jobs'
    resources :harvest_jobs, only: [:create, :update, :show, :index]
    resources :enrichment_jobs, only: [:create, :update, :show, :new]
    resources :harvest_schedules, except: [:show]
    resources :collection_statistics, only: [:index, :show]
    resources :link_check_rules, except: [:show]
    resources :suppress_collections
    resources :collection_records, only: [:index, :update]
  end

  devise_for :users
  resources :users, only: [:index, :edit, :update, :new, :create]
end
