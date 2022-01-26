# frozen_string_literal: true

namespace :admin do
  resources :users
  resources :activities, only: [:index]
end
