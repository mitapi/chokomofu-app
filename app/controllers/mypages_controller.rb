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
  def edit_account
    @account_user = current_user
    redirect_to mypage_path if @account_user.auth_kind_password?
  end

  def update_account
    @account_user = current_user
    return redirect_to mypage_path if @account_user.auth_kind_password?

    @account_user.assign_attributes(account_params.merge(auth_kind: :password))

    if @account_user.save(context: :upgrade)
      redirect_to mypage_path, notice: "アカウント連携が完了しました"
    else
      Rails.logger.debug("[upgrade] errors=#{@account_user.errors.full_messages.inspect}")
      render :edit_account, status: :unprocessable_entity
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