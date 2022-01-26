# frozen_string_literal: true

resources :harvest_jobs, only: [:create, :update, :show, :index]
