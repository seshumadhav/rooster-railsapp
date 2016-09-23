Rails.application.routes.draw do

  # If you setting the rails app on a new machine, first set root to sessions#new; launch the URL and then switch root to something else
  # root to: 'sessions#new'
  root to:"home#index"


  get 'sessions/welcome'

  resources :sessions
  get "/auth/:provider/callback" => 'sessions#create'
end
