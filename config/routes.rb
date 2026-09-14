Rails.application.routes.draw do
  devise_for :users
  root "trips#index"

  get "up" => "rails/health#show", as: :rails_health_check

  resources :trips, only: %i[index show] do
    resources :holds, only: :create
  end

  resources :holds, only: :show, param: :token do
    resources :bookings, only: :create
  end

  resources :bookings, only: %i[index show], param: :pnr do
    member do
      post :cancel
      get :reschedule, action: :reschedule_form
      post :reschedule
    end
  end
end
