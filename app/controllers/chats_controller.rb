class ChatsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_empty

  def show
    slot = resolve_time_slot(params[:time_slot]).to_sym
    @time_slot = slot
    weather = current_weather_slot
    @weather_slot = weather.presence || :any_weather

    # キャラを先に確定（※暫定）
    @character = Character.first!

    fallback = Conversation.find_by!(code: "conv.greet.morning.breakfast")

    followup_ids = ConversationChoice.where.not(next_conversation_id: nil).select(:next_conversation_id)

    scope = Conversation.where(character: @character, kind: :talk)
      .for_slot(@time_slot)
      .for_weather(@weather_slot)
      .where.not(id: followup_ids)

    @conv =
      if params[:conversation_id].to_s.match?(/\A\d+\z/)
        Conversation.find_by!(id: params[:conversation_id])
      else
        pick_weighted(scope)
      end

    @conv ||= fallback
    @character ||= Character.find(@conv.character_id)
    @choices = @conv.conversation_choices.order(:position)

    @conversation_blocks = @conv.text.to_s
      .split(/\n\s*\n/)
      .map { |block| block % { nickname: current_user.nickname } }
      .map(&:strip)
      .reject(&:blank?)
    @expression_keys = parse_expression_keys(@conv.expression_keys, @conversation_blocks.length)

    Rails.logger.debug "[conversation] code=#{@conversation.code}"
    Rails.logger.debug "[conversation] text=#{@conversation.text.inspect}"
  end


  def choose
    next_conv = Conversation.find(params[:next_conversation_id])

    interaction = current_user.interactions.new(
      kind: :talk,
      happened_at: Time.current,
      character_id: next_conv.character_id
    )

    unless interaction.save
      Rails.logger.warn("[chat choose] #{interaction.errors.full_messages}")
    end

    redirect_to chat_path(conversation_id: next_conv.id)
  end

  private

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

  def render_empty
    @conv = nil
    @character = nil
    @choices = []
    @empty = true
    render :show, status: :ok
  end

  def parse_expression_keys(raw_expression_keys, line_count)
    keys =
      if raw_expression_keys.is_a?(Array)
        raw_expression_keys
      elsif raw_expression_keys.present?
        JSON.parse(raw_expression_keys)
      else
        []
      end

    keys = [] unless keys.is_a?(Array)

    while keys.length < line_count
      keys << "face_idle"
    end

    keys
  rescue JSON::ParserError
    Array.new(line_count, "face_idle")
  end

  # スコープで絞られたものを対象にpoolに入れます
  def pick_weighted(conversations)
    pool = []

    conversations.each do |conv|
      weight = conv.weight.to_i
      weight = 1 if weight <= 0

      weight.times do
        pool << conv
      end
    end

    pool.sample
  end

  # @expression_keys を必ず配列にする（TEXTのままだとキーを正しく読めなくてフォールバックする）
  def parse_expression_keys(raw_value, block_count)
    keys =
      case raw_value
      when Array
        raw_value
      when String
        JSON.parse(raw_value)
      else
        []
      end

    keys = keys.map(&:to_s)
    keys += ["face_idle"] * (block_count - keys.size)

    keys.first(block_count)
  rescue JSON::ParserError
    ["face_idle"] * block_count
  end
end