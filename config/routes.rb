Rails.application.routes.draw do
  resources :users, defaults: { format: 'json' }

  get "/typehead/:query", to: "users#search" 
end
