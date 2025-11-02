Rails.application.routes.draw do
  root 'top#index'
  resource :main, only: %i[show] 
  resource :chat, only: %i[show] 
<<<<<<< HEAD
  resource :nickname, only: %i[show create] 
=======
  resource :nickname, only: [:edit, :update]
  resource :account, only: [:edit, :update]

  get "/nickname", to: "nicknames#edit"
  get "/account", to: "nicknames#edit"
  get "/terms", to: "static#terms"
  get "/privacy", to: "static#privacy"
>>>>>>> nrc_backup
  get "up" => "rails/health#show", as: :rails_health_check
end
