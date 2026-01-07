class MypagesController < ApplicationController
  def show
  end

  def edit_nickname
    @user = current_user
  end

  def update_nickname
    @user = current_user
    @user.assign_attributes(user_params)

    if @user.save
      redirect_to mypage_path, notice: "プロフィールを更新したよ"
    else
      render :edit_nickname, status: :unprocessable_entity
    end
  end

  def how_to_play
  end

  private

  def user_params
    params.require(:user).permit(:nickname, :region)
  end
end