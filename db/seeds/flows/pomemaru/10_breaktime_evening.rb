#ストレッチorぽめ吸いでリフレッシュ！な会話（ぽめまる）

puts "[seeds] breaktime_evening: start"  # ← デバッグ用ログ

pomemaru = Character.find_or_create_by!(name: "ぽめまる")

breaktime_evening_greet = upsert_conversation(
  code: "conv.greet.evening.breaktime",
  attrs: {
    character_id: pomemaru.id,
    kind:         0,
    role:         0,
    time_slot:    :evening,
    weather_slot: :any_weather,
    min_affinity: 0,
    weight:       1,
    text: <<~TEXT
      おひさまが沈んできたの。
      今日もちょっとずつ夜に近づいてるのね。

      ぽめ、ちょっとのび～～ってしたい気分かも。
      のび～、ふう～って。%{nickname}しゃんも一緒にやる？
    TEXT
  }
)

breaktime_evening_branch_a = upsert_conversation(
  code: "conv.greet.evening.stretch",
  attrs: {
    character_id: pomemaru.id,
    kind:         0,
    role:         1,
    time_slot:    :evening,
    weather_slot: :any_weather,
    min_affinity: 0,
    weight:       1,
    text: <<~TEXT
      やった〜！じゃあ、ぽめが伸びの先生するの。
      一緒にのびのび、するのね！

      まずね……座ってても立ってもだいじょぶなの。
      おててを、そ〜っと上にのばして……
      ぐ〜〜〜って、背中をのびのびさせるの。

      ぽめが、いち、に〜、さん……って数えるね。
      そのまま、５秒くらい、のび〜ってするの！
      できたら、ふう〜って息をはいてね。

      つぎは肩を、右に３回、左に３回。
      くる、くる、するのね♪
      ぽめも、ちいさなおててを、んしょ、んしょって回してるの。

      ……どう？かんたんでしょ！
      のび～すると、すっごく気持ちいいの。
      %{nickname}しゃん、ぽめ伸び、気に入ってくれた？
    TEXT
  }
)

breaktime_evening_branch_b = upsert_conversation(
  code: "conv.greet.evening.pome_sui",
  attrs: {
    character_id: pomemaru.id,
    kind:         0,
    role:         1,
    time_slot:    :evening,
    weather_slot: :any_weather,
    min_affinity: 0,
    weight:       1,
    text: <<~TEXT
      わん……とってもお疲れなのね。
      じゃあ今日はとくべつに、ぽめ吸い……する？？

      ぽめは、おひさまの香りがするらしいのね。
      とくにおなかとか、吸い心地いいっていわれるの。
      %{nickname}しゃん、思うぞんぶん、ぽめを吸いまくるのね！
      
      …… …… ……
      …… …… ……（ぽめ吸い中）

      ……%{nickname}しゃん、ちょっとくすぐったいかも～！

      えっ、「ぽめ吸いに夢中になりすぎちゃった」の？

      そんなに気に入ってくれたの！
      %{nickname}しゃんがよろこんでくれて、ぽめもとっても嬉しいの。
      いいにおいだったでしょ～！
      
      それにしてもぽめ吸い、そんなにいいんだ……！
      ぽめも、おともだちぽめに「ぽめ吸い」、してみたいってお願いしようかな？
    TEXT
  }
)

upsert_choice(
  conversation:      breaktime_evening_greet,
  position:          1,
  label:             "一緒にやろう！",
  next_conversation: breaktime_evening_branch_a
)

upsert_choice(
  conversation:      breaktime_evening_greet,
  position:          2,
  label:             "疲れて動けない～",
  next_conversation: breaktime_evening_branch_b
)

puts "[seeds] greetings: done (greet_id=#{breaktime_evening_greet.id})"