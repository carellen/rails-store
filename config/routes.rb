Rails.application.routes.draw do
  root 'application#index'
  
  resources :items, only: [:index, :new, :create]
  resources :receipt_notes, only: [:index, :new, :create]
end
