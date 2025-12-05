class MainsController < ApplicationController
  before_action :require_onboarding, unless: -> { Rails.env.test? }

  def show
    @character = Character.first!  #あとで選択したキャラを出せるように書き換える！
  end

  private

  def require_onboarding
    return if @current_user&.nickname.present?
    redirect_to nickname_path
  end  
end
