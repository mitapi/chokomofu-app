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

    # 引き継ぎ設定済ならdone、そうでないならform
    if params[:form] == "1"
      @account_page = "form"
    elsif @account_user.auth_kind_password?
      @account_page = "done"
    else
      @account_page = "form"
    end
  end

  def update_account
    @account_user = current_user

    @account_user.assign_attributes(account_params)
    @account_user.auth_kind = :password

    if @account_user.save(context: :upgrade)
      @account_page = "done"
      render :edit_account, status: :ok
    else
      @account_page = "form"
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