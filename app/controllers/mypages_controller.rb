class MypagesController < ApplicationController
  def show
    @user = current_user
  end

  def edit_profile
    @user = current_user
  end

  def update_profile
    @user = current_user
    @user.assign_attributes(user_params)

    if @user.save
      redirect_to mypage_path, notice: "更新したよ"
    else
      render :edit_profile, status: :unprocessable_entity
    end
  end

  def how_to_play
  end

  # データアカウント化
  def account
    @user = current_user
    redirect_to mypage_path if @user.auth_kind == "password"
  end

  def update_account
    @user = current_user

    if @user.auth_kind == "password"
      redirect_to mypage_path and return
    end

    if @user.update(account_params.merge(auth_kind: :password))
      redirect_to mypage_path, notice: "アカウント連携が完了しました"
    else
      render :account, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:nickname, :region)
  end

  def account_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end