class SnacksController < ApplicationController
  def picker
    @snacks = Interaction.snack_types.keys
    render :picker
  end

  def give
    snack_key = params[:snack_type].to_s

    unless Interaction.snack_types.key?(snack_key)
      return render plain: "invalid snack", status: :unprocessable_entity
    end

    user = current_user
    character = Character.first!  # 後で選択中キャラに差し替え
 
    today_count = Interaction
      .where(user: user, character_id: character.id, kind: :snack)
      .where(happened_at: Time.zone.today.all_day)
      .count

    if today_count >= 3
      message = "今日のおやつはおしまいだよ"
      return render partial: "snacks/result",
                    locals: { snack_type: snack_key, message: message, limited: true }
    end

    Interaction.create!(
      user: user,
      character_id: character.id,
      kind: :snack,
      snack_type: snack_key,
      happened_at: Time.current
    )

    builder = SnackMessageBuilder.new(snack_type: snack_key)
    lines   = builder.lines

    render partial: "snacks/result",
           locals: {
             snack_type: snack_key,
             lines: lines,
             limited: false
           }
  end

  def tip
    snack_type = params[:snack_type].to_s

    title, text =
      case snack_type
      when "cookie"
        [
          "くまさんクッキーサンド",
          <<~TEXT
            くまさんのお顔をかたどったクッキーに、
            あまさ控えめなクリームをサンド。
            「モフスタ映えする」と、流行に敏感な
            もふもふたちから好評のおやつ。
          TEXT
        ]
      when "sasami"
        [
          "お野菜とささみのおやつ",
          <<~TEXT
            もふもふたちが大好きなささみに、
            お野菜をブレンドしたヘルシーおやつ。
            お野菜苦手な子でも、意外とおいしく食べてくれると好評。
          TEXT
        ]
      else
        ["おやつ", "おいしいよ。"]
      end

    render partial: "snacks/detail_panel", locals: { title: title, text: text, snack_type: snack_type }
  end

  def tip_close
    render inline: "<turbo-frame id='snack_detail_panel'></turbo-frame>"
  end

end