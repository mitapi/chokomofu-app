class MainsController < ApplicationController
  before_action :require_onboarding, unless: -> { Rails.env.test? }

  def show
    slot = resolve_time_slot(params[:time_slot]).to_sym
    @time_slot = slot
    @weather_slot   = current_weather_slot

    @character = Character.first!  #あとで選択したキャラを出せるように書き換える！
  end

  private

  def require_onboarding
    return if @current_user&.nickname.present?
    redirect_to nickname_path
  end

  # テストで時間固定する用の記述も残しておきます
  def resolve_time_slot(param)
    valid = %w[morning noon_01 noon_02 evening night late_night early_morning]
    slot = param.to_s.strip.downcase

    if Rails.env.development? || Rails.env.test?
      return slot if slot.present? && valid.include?(slot)
      return real_time_slot
    end
    real_time_slot
  end

  def real_time_slot
    h = Time.zone.now.hour
    case h
    when 5..10      then "morning"        # 5:00-10:59
    when 11..13     then "noon_01"        # 11:00-13:59
    when 14..15     then "noon_02"        # 14:00-15:59
    when 16..18     then "evening"        # 16:00-18:59
    when 19..21     then "night"          # 19:00-21:59
    when 22..23, 0  then "late_night"     # 22:00-0:59
    else                 "early_morning"  # 1:00-4:59
    end
  end
end
