# frozen_string_literal: true

resources :snippets do
  get 'current_version', on: :collection
  resources :snippet_versions, path: 'versions', only: [:show, :update] do
    get :current, on: :collection
  end
  get :versions, on: :member
end
