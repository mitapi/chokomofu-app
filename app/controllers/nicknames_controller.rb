class NicknamesController < ApplicationController
  before_action :redirect_if_onboarding_completed, only: :edit

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    agreed = params[:terms] == "1"
    name = user_params[:nickname]
    @user.nickname = name
    errors_added = false

    if name.blank?
      @user.errors.add(:nickname, "ニックネームを入力してください")
      errors_added = true
    elsif name.length > 10
      @user.errors.add(:nickname, "ニックネームは10文字以内で入力してください")
      errors_added = true
    elsif !name.match?(/\A[[:alnum:]\p{Hiragana}\p{Katakana}\p{Han}\p{Zs}]+\z/u)
      @user.errors.add(:nickname, "使用できない文字が含まれています")
      errors_added = true
    end

    unless agreed
      @user.errors.add(:terms, "利用規約への同意が必要です")
      errors_added = true
    end

    if @user.errors.any?
      return render :edit, status: :unprocessable_entity
    end

    @user.terms_agreed_at = Time.current
    @user.terms_version = "2025-10-30"

    if @user.save
      redirect_to welcome_guide_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:nickname)
  end
end
