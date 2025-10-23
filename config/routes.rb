Rails.application.routes.draw do
  root 'top#index'
  resource :main, only: %i[show] 
  resource :chat, only: %i[show] 
  resource :nickname, only: [:edit, :update]

  get "/nickname", to: "nicknames#edit"
  get "up" => "rails/health#show", as: :rails_health_check
end
