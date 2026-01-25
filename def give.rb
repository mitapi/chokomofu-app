  def give
    snack_key = params[:snack_type].to_s
    unless Interaction.snack_types.key?(snack_key)
      return render plain: "invalid snack", status: :unprocessable_entity
    end

    user = current_user
    character = Character.first! # 後で選択中キャラに差し替え

    today_count = Interaction
      .where(user: user, character_id: character.id, kind: :snack)
      .where(happened_at: Time.zone.today.all_day)
      .count

    if today_count >= 3
      lines = ["今日のおやつはおしまいだよ"]
      return render turbo_stream: turbo_stream.replace(
        "snack_result",
        partial: "snacks/result",
        locals: { character: character, snack_type: snack_key, lines: lines, limited: true }
      )
    end