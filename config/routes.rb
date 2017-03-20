Rails.application.routes.draw do
  get 'user_portal/index'

  # devise_for :users
 	Rails.application.routes.draw do
    devise_for :users, controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations'
    }
  end
  resources :time_off_request
  resources :manager
  resources :department
  resources :report
  resources :user
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'user_portal#index'
end
