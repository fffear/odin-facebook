Rails.application.routes.draw do
  #devise_scope :user do
  #  # root 'devise/sessions#new'
  #end

  root 'static_pages#home'

  resources :users, only: %i(index show) do
    resources :posts, only: %i(create)
  end

  get '/news_feed', to: 'posts#index'
  resources :posts, only: %i(destroy) do
    resources :likes, only: %i(create)
    resources :comments, only: %i(create)
  end
  
  resources :friend_requests, only: %i(create destroy)
  resources :friendships, only: %i(create destroy)

  devise_for :users, path: "", path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    sign_up: 'register'
  }, controllers: { 
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations'
  }


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
