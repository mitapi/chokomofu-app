class WelcomesController < ApplicationController
  before_action :redirect_if_onboarding_completed

  def show; end
  def guide; end
end