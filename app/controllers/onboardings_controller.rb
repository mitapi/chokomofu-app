class OnboardingsController < ApplicationController
  before_action :redirect_if_onboarding_completed, only: :edit

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    @user.assign_attributes(user_params)

    if user_params[:terms].to_s == "1" && @user.terms_agreed_at.blank?
      @user.terms_agreed_at = Time.current
      @user.terms_version = "2025-10-30"
    end

    if @user.save
      redirect_to welcome_guide_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:nickname, :region, :terms)
  end
end
