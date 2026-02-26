Rails.application.routes.draw do
  root 'top#index'
  resource :chat, only: %i[show] 
  resource :onboarding, only: [:edit, :update]
  resource :account, only: [:edit, :update]
  resource :welcome, only: %i[show]

  resource :main, only: [:show] do
    get :menu
  end
  resource :mypage, only: :show do
    get   :profile, action: :edit_profile
    patch :profile, action: :update_profile
    get   :howto
  end

  resource :snack, only: [] do
    get  :picker   # 候補を出す
    post :give     # 選んだおやつをあげる
    get  :tip      # 説明吹き出し
    get  :tip_close
  end

  resource :mofu_diaries, only: [] do
    collection do
      get  :confirm_today
      post :create_today
    end
  end

  get "/onboarding", to: "onboardings#edit"
  get "welcome/guide", to: "welcomes#guide"
  get "/account", to: "onboardings#edit"
  get "/howto", to: "howtos#show", as: :howto

  get "/terms", to: "static#terms"
  get "/privacy", to: "static#privacy"

  get "up" => "rails/health#show", as: :rails_health_check

  get "/mofu_diaries/share/:token", to: "mofu_diaries#share", as: :share_mofu_diary
  get "/mofu_diaries/share/:share_token/og.png", to: "mofu_diaries#og", as: :og_mofu_diary

  post "/chat/choose", to: "chats#choose"
end
