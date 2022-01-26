# frozen_string_literal: true

resources :harvest_schedules, except: [:show] do
  put :update_all, on: :collection
end
