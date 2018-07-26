Rails.application.routes.draw do
  root 'application#index'

  resources :items, only: [:index, :new, :create]
  resources :receipt_notes, only: [:index, :new, :create, :show]
  resources :delivery_notes, only: [:index, :new, :create, :show]
  resource :report, only: :show
end
