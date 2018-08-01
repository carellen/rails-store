Rails.application.routes.draw do
  root 'application#index'

  resources :items, only: [:index, :new, :create]
  resources :receipt_notes, only: [:index, :new, :create, :show] do
    post 'posting', on: :member
  end
  resources :delivery_notes, only: [:index, :new, :create, :show] do
    member do
      post 'posting'
      post 'undo'
    end
  end
  resource :report, only: :show
end
