ManifesteSe::Application.routes.draw do
  match '/auth/:provider/callback',   :to => 'sessions#create'
  resources :sessions, :only => [:new]
  resources :campaigns, :only => [:index, :show, :new, :create]
  root :to => 'campaigns#index'
end
