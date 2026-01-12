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

  private

  def user_params
    params.require(:user).permit(:nickname, :region)
  end
end