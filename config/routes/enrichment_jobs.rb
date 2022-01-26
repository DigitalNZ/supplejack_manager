# frozen_string_literal: true

resources :enrichment_jobs, only: [:create, :update, :show, :new]
