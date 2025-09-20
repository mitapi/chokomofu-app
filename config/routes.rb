Rails.application.routes.draw do
  root 'top#index'

  get "up" => "rails/health#show", as: :rails_health_check
end
