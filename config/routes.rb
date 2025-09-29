Rails.application.routes.draw do
  root to: redirect('/main'), status: 302
  root 'top#index'
  resource :main, only: %i[show] 
  resource :chat, only: %i[show] 
  get "up" => "rails/health#show", as: :rails_health_check
end
