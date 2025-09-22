Rails.application.routes.draw do
  root 'top#index'
  resource :play, only: %i[show] 

  get "up" => "rails/health#show", as: :rails_health_check
end
