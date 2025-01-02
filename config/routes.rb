Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations", sessions: "users/sessions" }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

defaults format: :json do
  namespace :api do
    namespace :v1 do
      post "strava", to: "strava#create"
      get "strava", to: "strava#index"
      get "ride_stats", to: "ride_stats#index"
      resources :settings, only: [ :update ]
      resources :services, only: [ :show ]
      resources :tasks, only: [ :index ]
      resources :strava, only: [ :index, :create ] do
        collection do
          get :fetch_bikes
        end
      end
      resources :bikes, only: [ :create, :update ]
      resources :bikes, only: [] do
        resources :service_intervals, only: [ :index ]
      end
    end
  end
end

  root "public#index"
  get "privacy-policy", to: "public#privacy_policy"
  post "waitlist", to: "public#waitlist"
end
