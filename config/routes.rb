Rails.application.routes.draw do
  resources :scenarios do
    member do
      get :translate
      get :locations
      get :export
    end
    collection do
      get 'build/:date', action: :build
    end
  end

  resources :lines, only: [:update] do
    member do
      post :who
    end
  end

  resources :locations, only: [:update]

  devise_for :users

  root to: 'scenarios#index'
end
