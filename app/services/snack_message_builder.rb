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
        [{ text: "……？", image: "face_idle" }]
      end

    raw.map do |item|
      {
        text: interpolate(item[:text]),
        image: item[:image]
      }
    end
  end

  def interpolate(line)
    line % { nickname: @user.nickname }
  end

  private

  def cookie_variations
    [
      [
        {
          text: "！！ %{nickname}しゃん、これ、甘くてとってもおいしいの。\nさくさくのクッキー、ふわふわクリーム……！",
          image: "face_surprise"
        },
        {
          text: "こんなにおいしいおやつ、ぜったい「お気に入りおやつメモ」に、メモしとかないと……！！",
          image: "face_memo_smile"
        },
        {
          text: "えっと、あまくておいしい……くまさんのお顔もかわいく……クリームも、お空にうかぶ雲のようにふわふわで……っと♪",
          image: "face_memo_normal"
        }
      ],
      [
        {
          text: "さく、さく、はむ、はむ。\n（夢中で食べている）",
          image: "face_eat_02"
        },
        {
          text: "はっ！おいしすぎて、ついついぜんぶ食べちゃったの。\n%{nickname}しゃんにも、分けてあげようとおもってたのに……！！",
          image: "face_surprise"
        },
        {
          text: "えっ、これはぽめが全部たべていいの？",
          image: "face_eat_01"
        },
        {
          text: "えへへ……%{nickname}しゃん、やさしいの。\n次のおやつは、はんぶんこして一緒に食べようね！",
          image: "face_kirakira"
        },
      ],
      [
        {
          text: "おいし～！そういえば、この「どうぶつクッキー」、くまさんの他にもいろんなお顔があるんだよね。\nうさぎさん、ねこさん、あとなんだっけ……？",
          image: "face_kirakira"
        },
        {
          text: "「ぽめのはないの？」って？\nう～ん、ぽめのお顔のクッキーはあったかなあ……？",
          image: "face_hmm"
        },
        {
          text: "そだ、また今度ぽめのお友だちに聞いてみるのね。\nその子はね、すごーくおやつに詳しいねこさんなの！\n%{nickname}しゃんも会ってみたい？",
          image: "face_happy"
        }
      ]
    ]
  end

  def sasami_variations
    [
      [
        {
          text: "もぐもぐ……このささみ、とってもおいしいの～！！\nえっ、お野菜が残ってる？？",
          image: "face_eat_01"
        },
        {
          text: "ぽめ、実はお野菜があんまり……\nおいしいから食べてみてって？むむむ、%{nickname}しゃんが言うなら……",
          image: "face_hmm"
        },
        {
          text: "（ぱくり……）",
          image: "face_eat_01"
        },
        {
          text: "！！ このお野菜、ぜんぜん苦くないの！\nぽめ、これなら食べられるかも……！？",
          image: "face_kirakira"
        }
      ],
      [
        {
          text: "ぽめ、お肉のおやつもだいすきなの。このささみとか、毎日たべたいお味……♪",
          image: "face_happy"
        },
        {
          text: "はっ、でもこんなおいしいささみなんだから、実はけっこう、「お高級」なおやつ……ってこと！？",
          image: "face_surprise"
        },
        {
          text: "あとちょっとだけ残ってる。\nお高級かもしれないささみ……ぽめ、ゆっっっくり、あじわって食べるのね。",
          image: "face_kirakira"
        }
      ]
    ]
  end
end