module ConversationsHelper
  CHAR_DIR_BY_NAME = {
    "ぽめまる" => "pomemaru"
  }.freeze

  def character_dir_for(character)
    CHAR_DIR_BY_NAME[character.name] || character.name.to_s.parameterize
  end

  # config/expressions.ymlから表情画像を持ってくる
  def expression_image_path(character_dir: "pomemaru", expression: :face_idle)
    EXPRESSIONS.dig(:shared, character_dir.to_sym, expression.to_sym, :src) ||
      EXPRESSIONS.dig(:shared, character_dir.to_sym, :face_idle, :src)
  end

  # ① ニックネームを差し込んだ「プレーンテキスト」を返す共通メソッド
  def conversation_text_body(conv)
    render_text_with_nickname(conv&.text, current_user)
  end

  # ② ふつうに全部まとめて表示したいとき用（今までどおり）
  def conversation_text_html(conv)
    text = conversation_text_body(conv)
    simple_format(h(text))
  end

  # ③ Stimulus用に文章を区切る　split(/\n{2,}/)は２行以上の改行で区切るという意味
  def conversation_lines(conv)
    text = conversation_text_body(conv)
    text.split(/\n{2,}/).map(&:strip).reject(&:blank?)
  end

  def choice_label_html(choice)
    render_text_with_nickname(choice&.label, current_user)
  end

  def render_text_with_nickname(text, user)
    text.to_s % { nickname: user&.nickname.presence || "ゲスト" }
  end
end