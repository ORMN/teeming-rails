Rails.application.routes.draw do
  devise_for :users
  namespace :api do
    resources :members
    resources :users
  end

  post 'api/login', to: 'sessions#login'

  resources :users do
    member do
      put :update_email
      put :update_password
    end

    collection do
      get :home
      get :profile
      get :account
      get :privacy_policy
      get :bylaws
      get :code_of_conduct
      put :redo_initial_steps
    end
  end

  resources :chapters, only: [:index, :show]
  resources :elections, only: [:index, :show] do
    resources :races, shallow: true
  end
  resources :events, only: [:index, :show]
  resources :event_rsvps, only: [:new, :create, :edit, :update]
  resources :candidacies

  # resources :questionnaires do
  #   resources :questionnaire_sections, shallow: true do
  #     member do
  #       put :move_up
  #       put :move_down
  #     end
  #   end
  #   resources :questions, shallow: true do
  #     member do
  #       put :move_up
  #       put :move_down
  #     end
  #   end
  #   resources :choices, shallow: true do
  #     member do
  #       put :move_up
  #       put :move_down
  #     end
  #   end
  # end
  #
  # resources :choices, only: [] do
  #   collection do
  #     get :new_blank
  #   end
  #   member do
  #     get :move_up
  #     get :move_down
  #     get :delete
  #   end
  # end

  unauthenticated :user do
    devise_scope :user do
      root 'brochure#home', as: :unauthenticated_root
    end
  end

  authenticated :user do
    root to: 'users#home'
  end
end
