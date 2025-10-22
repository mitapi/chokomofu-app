Rails.application.routes.draw do
  root 'top#index'
  resource :main, only: %i[show] 
  resource :chat, only: %i[show] 
  resource :nickname, only: %i[show create] 
  get "up" => "rails/health#show", as: :rails_health_check
end
