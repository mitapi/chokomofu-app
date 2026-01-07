class MypagesController < ApplicationController
  def show
  end

  def edit_nickname
    @user = current_user
  end

  def update_nickname
    @user = current_user

    if @user.save
      flash[:notice] = "プロフィールを更新しました"
      redirect_to mypage_nickname_path
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