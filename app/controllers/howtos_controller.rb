class HowtoController < ApplicationController
  def show
    @from = params[:from]
    @back_path =
      case @from
      when "mypage" then how_to_play_mypage_path
      else
        main_path
      end
  end
end