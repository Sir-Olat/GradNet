Rails.application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'registrations' }
  get '/users/:id/edit_profile' => 'users#edit', as: :edit_profile
  post '/users/:id/info' => 'users#update_info', as: :info
  get '/users/:id/change_password' => 'users#get_password', as: :edit_password
  put '/users/:id/update_password' => 'users#update_password', as: :change_password

  resources :users, :only =>[:show]
  match '/users', to: 'users#index', via: 'get'
  match '/users/:id', to: 'users#show', via: 'get'


  authenticated :user do
    root 'discussions#index'
  end
  root 'home#index'


  resources :discussions do

    member do
      post '/like' => 'discussions#like'
      delete '/unlike' => 'discussions#unlike'
    end
  end
  resources :comments



  resources :categories

  # get '/careers' => 'jobs#index',

  resources :jobs, path: 'careers'

  get 'tags/:tag', to: 'jobs#index', as: :tag





  get 'home/about'

  # devise_for :users

end
