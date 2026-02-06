class MofuDiariesController < ApplicationController
  skip_before_action :ensure_current_user, only: [:share, :og]

  def show
    @mofu_diary = current_user.mofu_diaries.find(params[:id])
  end

  def create_today
    today = Time.zone.today
    diary = current_user.mofu_diaries.find_or_initialize_by(date: today)

    if diary.new_record?
      built = MofuDiaryBuilder.new(user: current_user, date: today).build

      diary.assign_attributes(
        title: "#{today.strftime('%-m/%-d')} のもふ日記",
        line1: built.line1,
        line2: built.line2,
        weather_slot: built.weather_slot,
        time_slot: built.time_slot,
        character_key: built.character_key,
        pose: built.pose
      )
      diary.save!
    end

    redirect_to mofu_diary_path(diary)
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