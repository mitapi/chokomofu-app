class ChatsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_empty

  def show
    slot = resolve_time_slot(params[:time_slot]).to_sym
    @time_slot = slot
    weather    = current_weather_slot

    # seed に合わせたフォールバック
    fallback = Conversation.find_by!(code: "conv.greet.morning.breakfast")

    @conv =
      if params[:conversation_id].to_s.match?(/\A\d+\z/)
        Conversation.find_by!(id: params[:conversation_id])
      else
        character = Character.first!   # あとで選択キャラに置き換えメソッド作る

      Conversation
        .where(character: @character, kind: :talk)  # kind が enum なら kind: :talk
        .for_slot(slot)                             # time_slot: [slot, :any]
        .for_weather(weather)                       # weather_slot: [weather, :any]
        .order("RANDOM()")                          # 候補からランダム
        .first
      end

    @conv ||= fallback

    @character = Character.find(@conv.character_id)
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
    when 5..11  then "morning"    # 5:00-11:59
    when 12..15 then "noon"       # 12:00-15:59
    when 16..18 then "evening"    # 16:00-18:59
    when 18..23 then "night"      # 18:00-23:59
    else             "late_night" # 0:00-4:59
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