Rails.application.routes.draw do
  get 'user_portal/index'

  devise_for :users
  resources :time_off_request
  resources :manager
  resources :department
  resources :report
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'user_portal#index'
end
