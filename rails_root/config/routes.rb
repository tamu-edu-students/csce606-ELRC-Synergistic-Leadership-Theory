# frozen_string_literal: true

Rails.application.routes.draw do
  # Defines the root path route ("/")
  root 'home#index'

  get 'about', to: 'about#index'

  resources :survey_responses
  resources :survey_profiles

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check
end
