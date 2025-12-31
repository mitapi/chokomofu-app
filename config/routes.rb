Rails.application.routes.draw do
  root 'top#index'
  resource :main, only: %i[show] 
  resource :chat, only: %i[show] 
  resource :onboarding, only: [:edit, :update]
  resource :account, only: [:edit, :update]
  resource :welcome, only: %i[show]

  get "/onboarding", to: "onboardings#edit"
  get "welcome/guide", to: "welcomes#guide"
  get "/account", to: "onboardings#edit"
  get "/terms", to: "static#terms"
  get "/privacy", to: "static#privacy"
  get "up" => "rails/health#show", as: :rails_health_check
end
