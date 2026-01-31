class SnackMessageBuilder
  def initialize(user:, snack_type:)
    @user = user
    @snack_type = snack_type.to_s
  end

  def lines
    raw =
      case @snack_type
      when "cookie"
        cookie_variations.sample
      when "sasami"
        sasami_variations.sample
      else
        ["……？"]
      end

    raw.map { |line| interpolate(line) }
  end

  def interpolate(line)
    line % { nickname: @user.nickname }
  end

  private

  def cookie_variations
    [
      [
        "！！ %{nickname}しゃん、これ、甘くてとってもおいしいの。\nさくさくのクッキー、ふわふわクリーム……！",
        "こんなにおいしいおやつ、ぜったい「お気に入りおやつメモ」に、メモしとかないと……！！",
        "えっと、あまくておいしい……くまさんのお顔もかわいく……クリームも、お空にうかぶ雲のようにふわふわで……っと♪"
      ],
      [
        "さく、さく、はむ、はむ。\n（夢中で食べている）",
        "はっ！おいしすぎて、ついついぜんぶ食べちゃったの。\n%{nickname}しゃんにも、分けてあげようとおもってたのに……！！",
        "えっ、これはぽめが全部たべていいの？えへへ……%{nickname}しゃん、やさしいの。\n次のおやつは、はんぶんこして一緒に食べようね！"
      ],
      [
        "おいし～！そういえば、この「どうぶつクッキー」、くまさんの他にもいろんなお顔があるんだよね。\nうさぎさん、ねこさん、あとなんだっけ……？",
        "「ぽめのはないの？」って？\nう～ん、ぽめのお顔のクッキーはあったかなあ……？",
        "そだ、また今度ぽめのお友だちに聞いてみるのね。\nその子はね、すごーくおやつに詳しいねこさんなの！\n%{nickname}しゃんも会ってみたい？"
      ]
    ]
  end

  def sasami_variations
    [
      [
        "もぐもぐ……このささみ、とってもおいしいの～！！\nえっ、お野菜が残ってる？？",
        "ぽめ、実はお野菜があんまり……\nおいしいから食べてみてって？むむむ、%{nickname}しゃんが言うなら……",
        "（ぱくり……）",
        "！！ このお野菜、ぜんぜん苦くないの！\nぽめ、これなら食べられるかも……！？"
      ],
      [
        "ぽめ、お肉のおやつもだいすきなの。このささみとか、毎日たべたいお味……♪",
        "はっ、でもこんなおいしいささみなんだから、実はけっこう、「お高級」なおやつ……ってこと！？",
        "あとちょっとだけ残ってる。\nお高級かもしれないささみ……ぽめ、ゆっっっくり、あじわって食べるのね。"
      ]
    ]
  end
end