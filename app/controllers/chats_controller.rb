class ChatsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_empty

  def show
    @time_slot = resolve_time_slot(params[:time_slot])

    default_conv = Conversation.find_by!(code: "conv.greet.morning.default")

    if params[:conversation_id].to_s.match?(/\A\d+\z/)
      @conv = Conversation.find_by!(id: params[:conversation_id])
    else
      @conv = default_conv
    end

    @character = Character.find(@conv.character_id)
    @choices = ConversationChoice.where(conversation_id: @conv.id).order(:position)
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
    hour = Time.zone.now.hour
    return "late_night" if hour > 5
    return "morning"    if hour > 12
    return "noon"       if hour > 18
    "night"
  end

  def render_empty
    @conv = nil
    @character = nil
    @choices = []
    @empty = true
    render :show, status: :ok
  end
end