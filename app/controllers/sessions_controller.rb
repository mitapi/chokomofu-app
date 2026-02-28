class SessionsController < ApplicationController
  def new
  end

  def create
    email = params[:email].to_s.strip.downcase
    user  = User.find_by(email:)

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to main_path, notice: "ログインしました"
    else
      flash.now[:alert] = "メールアドレスかパスワードが違うよ"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to root_path, notice: "ログアウトしました"
  end
end