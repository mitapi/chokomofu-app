class SnackMessageBuilder
  def initialize(snack_type:)
    @snack_type = snack_type.to_sym
  end

  def lines
    case @snack_type
    when :cookie
      cookie_variations.sample
    when :jerky
      jerky_variations.sample
    else
      ["……？"]
    end
  end

  private

  # 文章はあとで修正する！

  def cookie_variations
    [
      [
        "わっ、クッキーだ！🍪",
        "いただきまーす…もぐもぐ…",
        "おいしい〜！またほしいな🐾"
      ],
      [
        "クッキーの匂いがする…！🍪",
        "さくっ…もぐっ…",
        "しあわせ…ふわぁ…"
      ],
      [
        "えっ、いいの？クッキー？",
        "もぐもぐ…サクサク…",
        "ありがと〜！きょう最高だよ🐶"
      ]
    ]
  end

  def jerky_variations
    [
      [
        "ささみジャーキー！？🐔",
        "これだいすき！",
        "はむはむ…しあわせ〜"
      ],
      [
        "ジャーキーだ！やったー！",
        "はむっ…うまっ…",
        "もっと食べたいな～🐾"
      ]
    ]
  end
end