class SessionsController < ApplicationController
  def new
  end

  def create
    email = params[:email].to_s.strip.downcase
    user  = User.find_by(email:)

    if user&.authenticate(params[:password])
      reset_session
      session[:user_id] = user.id
      cookies.delete(:guest_uid)
      redirect_to main_path, notice: "ログインしました"
    else
      flash.now[:alert] = "メールアドレスかパスワードが違うよ"
      render :new, status: :unprocessable_entity
    end
  end
end