# frozen_string_literal: true

resources :parsers do
  put :allow_flush, on: :member
  get :datatable, on: :collection, constraints: { format: :json }

  resources :parser_versions, path: :versions, only: [:show, :update] do
    get :current, on: :collection
    get :new_enrichment, on: :member
    get :new_harvest, on: :member
  end

  get :versions, on: :member
  get :delete, on: :member, as: :delete
  get :edit_meta, on: :member
end
