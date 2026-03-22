# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users, only: %i[new create]
  resource :session, only: %i[new create destroy]

  namespace :profile do
    resources :home, only: :index
    resources :recipes, param: :slug do
      get :edit_details, on: :member
      get :secret, on: :collection
      get :drafts, on: :collection

      scope module: :recipes do
        resources :ingredient_groups, only: %i[index new create edit update] do
          scope module: :ingredient_groups do
            resources :recipe_ingredients, only: %i[new index create update] do
              get :batch_edit, on: :collection
            end
          end
        end

        resources :nutrition_facts, only: %i[index edit update]
      end
    end

    root to: 'home#index'
  end

  resources :recipes, param: :slug
  resources :rooms do
    resources :messages
  end
  resource :password, only: %i[show edit update] do
    post :recover
  end

  root to: 'recipes#index'

  get 'up' => 'rails/health#show', as: :rails_health_check
end
