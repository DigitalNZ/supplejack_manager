# frozen_string_literal: true

devise_for :users

resources :users, only: [:index, :edit, :update, :new, :create] do
  post 'mfa', on: :member
end
