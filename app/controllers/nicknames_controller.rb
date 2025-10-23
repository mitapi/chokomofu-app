class NicknamesController < ApplicationController
  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(nickname_params)
      flash[:notice] = "ニックネームを保存しました"
      redirect_to main_path
    else
      flash.now[:danger] = "ニックネームを保存できませんでした"
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:nickname)
  end
end
