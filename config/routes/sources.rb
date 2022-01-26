resources :sources, except: [:destroy] do
  get :reindex, on: :member
end
