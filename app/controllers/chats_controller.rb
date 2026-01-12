class ChatsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_empty

  def show
    slot = resolve_time_slot(params[:time_slot]).to_sym
    @time_slot = slot
    weather = current_weather_slot
    @weather_slot = weather.presence || :any_weather

    # seed に合わせたフォールバック
    fallback = Conversation.find_by!(code: "conv.greet.morning.breakfast")

    @conv =
      if params[:conversation_id].to_s.match?(/\A\d+\z/)
        Conversation.find_by!(id: params[:conversation_id])
      else
        @character = Character.first!   # あとで選択キャラに置き換えメソッド作る

      Conversation
        .where(character: @character, kind: :talk, role: :entry)
        .for_slot(@time_slot)
        .for_weather(@weather_slot)
        .order("RANDOM()")           # 候補からランダムに抽出
        .first
      end

    @conv ||= fallback

    @character ||= Character.find(@conv.character_id)
    @choices = @conv.conversation_choices.order(:position)
  end

  private

  # テストで時間固定する用の記述も残しておきます
  def resolve_time_slot(param)
    valid = %w[morning noon night late_night]
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

  def render_empty
    @conv = nil
    @character = nil
    @choices = []
    @empty = true
    render :show, status: :ok
  end
end