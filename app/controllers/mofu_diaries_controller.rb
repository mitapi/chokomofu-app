class MofuDiariesController < ApplicationController
  skip_before_action :ensure_current_user, only: [:share, :og]

  def show
    @mofu_diary = current_user.mofu_diaries.find(params[:id])
  end

  def create_today
    today = Time.zone.today
    @mofu_diary = current_user.mofu_diaries.find_or_initialize_by(date: today)

    if @mofu_diary.new_record?
      built = MofuDiaryBuilder.new(user: current_user, date: today).build

      @mofu_diary.assign_attributes(
        title: "#{today.strftime('%-m/%-d')} のもふ日記",
        line1: built.line1,
        line2: built.line2,
        weather_slot: built.weather_slot,
        time_slot: built.time_slot,
        character_key: built.character_key,
        pose: built.pose
      )
      @mofu_diary.save!
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to mofu_diary_path(@mofu_diary) }
   end
  end

  def confirm_today
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to main_path }
    end
  end

  def share
    @mofu_diary = MofuDiary.find_by!(share_token: params[:share_token])
  end

  def og
    diary = MofuDiary.find_by!(share_token: params[:share_token])

    path = Rails.root.join("tmp", "og_mofu_diary_#{diary.id}.png")
    OgImageGenerator.new(diary).generate_to!(path)

    send_file path, type: "image/png", disposition: "inline"
  end
end