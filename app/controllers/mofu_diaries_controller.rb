class MofuDiariesController < ApplicationController
  def show
    @mofu_diary = current_user.mofu_diaries.find(params[:id])
  end

  def create_today
    today = Time.zone.today

    diary = current_user.mofu_diaries.find_or_initialize_by(date: today)

    if diary.new_record?
      diary.assign_attributes(
        title: "#{today.strftime('%-m/%-d')} のもふ日記",
        line1: "きょうは もふもふ したよ",
        line2: "また あそぼうね 🐾",
        weather_slot: 0,
        time_slot: 0,
        character_key: "pomemaru"
      )
      diary.save!
    end

    redirect_to mofu_diary_path(diary)
  end
end