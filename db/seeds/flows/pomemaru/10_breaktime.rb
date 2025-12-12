#休憩でもふもふ提供してくれる会話（ぽめまる）

puts "[seeds] snack: start"  # ← デバッグ用ログ

pomemaru = Character.find_or_create_by!(name: "ぽめまる")

breaktime_greet = upsert_conversation(
  code: "conv.greet.noon_02.breaktime",
  attrs: {
    character_id: pomemaru.id,
    kind:         0,          # talk
    time_slot:    :any,
    weather_slot: :any_weather,
    min_affinity: 0,
    weight:       1,
    text: <<~TEXT
      %{nickname}しゃん、ぽめがきましたよ〜。
      もふもふを提供しにきたの。
    TEXT
  }
)

breaktime_branch_a = upsert_conversation(
  code: "conv.greet.noon_02.mofumofu",
  attrs: {
    character_id: pomemaru.id,
    kind:         0,
    time_slot:    :any,
    weather_slot: :any_weather,
    min_affinity: 0,
    weight:       1,
    text: <<~TEXT
      ぽめのこと、なでなでしてくれるの？
      なでなでだいすきなの！どぞ、どぞ♪

      ぽめはね、お顔の下をもふもふされるのがすきなの。
      あとはね、おみみのマッサージなんかもされちゃうと……
      ぽめ、しっぽがぶんぶんしちゃうの！

      あ～、そこそこ……
      %{nickname}しゃん、実はぽめなで検定１級取得者、なのね……？
      ぽめのほうが癒されちゃってるかも～……すや……
    TEXT
  }
)

breaktime_branch_b = upsert_conversation(
  code: "conv.greet.noon_02.get_treat",
  attrs: {
    character_id: pomemaru.id,
    kind:         0,
    time_slot:    :any,
    weather_slot: :any_weather,
    min_affinity: 0,
    weight:       1,
    text: <<~TEXT
      えっ！！おやつ！？おやつくれるの～！？
      ぽめ、おやつだいすきなの！

      今日のおやつは……あ！お星さまのかたちのカリカリだ～！
      これね、ぽめがずっと食べてみたいな〜って
      思ってたやつなの！

      でも、こんなにかわいいおやつ、
      食べるのがもったいない気持ちになっちゃいそう……！

      毎日いっこずつ食べられるように、とっておきたいくらいなの。
      あ、でもやっぱりもういっこだけ……

      ……%{nickname}しゃん、これ、サクサクでおいしいからとまらないの。
      サクサク……もぐもぐ……サクサク……

      これはね、「ベストオブぽめおやつランキング」に
      入っちゃうおいしさ、なの！
      おいしすぎて……ぽめのしっぽ、ふりふりしちゃうのね♪
    TEXT
  }
)

upsert_choice(
  conversation:      breaktime_greet,
  position:          1,
  label:             "撫でさせて〜",
  next_conversation: breaktime_branch_a
)

upsert_choice(
  conversation:      breaktime_greet,
  position:          2,
  label:             "おやつあげよっか！",
  next_conversation: breaktime_branch_b
)

puts "[seeds] greetings: done (greet_id=#{breaktime_greet.id})"