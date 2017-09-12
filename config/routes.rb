Rails.application.routes.draw do
  get 'scans/index'

  get 'scans/new'

  get 'sub_domains/index'

  root 'session#new'
  get '/index', to: 'admin#index'
  get '/login', to: 'session#new'
  post '/login', to: 'session#create'
  get '/domains', to: 'domains#index'
  post '/domains', to: 'domains#create'
  post '/dimport', to: 'sub_domains#import'
  get '/dexport/:id', to: 'sub_domains#export'
  resources :domains
  resources :sub_domains
  resources :scans
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
