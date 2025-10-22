class MainsController < ApplicationController
  before_action :require_onboarding, unless: -> { Rails.env.test? }

  def show; end

  private

  def require_onboarding
    return if @current_user&.nickname.present?
    redirect_to nickname_path
  end  
end
