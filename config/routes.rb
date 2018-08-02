Rails.application.routes.draw do
  concern :postable do
    resource :document_posting, only: [:index, :create, :show, :destroy]
  end
  root 'application#index'

  resources :items, only: [:index, :new, :create]
  resources :receipt_notes, concerns: :postable, only: [:index, :new, :create, :show]
  resources :delivery_notes, concerns: :postable, only: [:index, :new, :create, :show]
  resource :report, only: :show
  resource :sale_report, only: :show
end
