Rails.application.routes.draw do
  #devise_scope :user do
  #  # root 'devise/sessions#new'
  #end

  root 'static_pages#home'

  resources :users, only: %i(index show)

  devise_for :users, path: "", path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    sign_up: 'register'
  }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
