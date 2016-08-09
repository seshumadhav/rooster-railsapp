Rails.application.routes.draw do

  # root to: 'sessions#new'
  root to:"home#index"

  resources :sessions, only: :index
  get "/auth/:provider/callback" => 'sessions#create'
end
