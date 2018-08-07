Rails.application.routes.draw do
  concern :postable do
    resources :document_posting, only: [:index, :create, :show, :destroy]
  end
  root 'application#index'

  resources :items, only: [:index, :new, :create]
  resources :receipt_notes, concerns: :postable, only: [:index, :new, :create, :show]
  resources :delivery_notes, concerns: :postable, only: [:index, :new, :create, :show]
  resource :report, only: :show
end
