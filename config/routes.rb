Rails.application.routes.draw do

  # If you setting the rails app on a new machine, first set root to sessions#new; launch the URL and then switch root to something else
  # root to: 'sessions#new'
  root to:"home#index"

  resources :sessions, only: :index
  get "/auth/:provider/callback" => 'sessions#create'
end
