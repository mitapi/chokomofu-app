Rails.application.routes.draw do
  root 'top#index'
  resource :main, only: %i[show] 
  resource :chat, only: %i[show] 
  resource :onboarding, only: [:edit, :update]
  resource :account, only: [:edit, :update]
  resource :welcome, only: %i[show]

  resource :mypage, only: :show do
    get   :profile, action: :edit_profile
    patch :profile, action: :update_profile
    get   :how_to_play
  end

  get "/onboarding", to: "onboardings#edit"
  get "welcome/guide", to: "welcomes#guide"
  get "/account", to: "onboardings#edit"
  get "/terms", to: "static#terms"
  get "/privacy", to: "static#privacy"
  get "up" => "rails/health#show", as: :rails_health_check
end
