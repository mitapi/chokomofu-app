#夜ごはん食べた？の会話（ぽめまる）

puts "[seeds] dinner: start"  # ← デバッグ用ログ

pomemaru = Character.find_or_create_by!(name: "ぽめまる")

dinner_greet = upsert_conversation(
  code: "conv.greet.night.dinner",
  attrs: {
    character_id: pomemaru.id,
    kind:         0,
    role:         0,
    time_slot:    :night,
    weather_slot: :any_weather,
    weight:       1,
    text:         "おなかすいた～！夜ごはん、夜ごはん♪"
  }
)

dinner_branch_a = upsert_conversation(
  code: "conv.greet.night.before_dinner",
  attrs: {
    character_id: pomemaru.id,
    kind:         0,
    role:         1,
    time_slot:    :night,
    weather_slot: :any_weather,
    weight:       1,
    text: <<~TEXT
      うん！ぽめ、今日はおしごとしてたらちょっと遅くなっちゃった。
      おなかぺこぺこなの～！

      そうそう、ぽめは「ほしのけ」をふわふわにして
      まるくまとめるおしごとしてるんだよ！

      ほしのけっていうのは、
      夜になると星からふわっと落ちてくる
      キラキラの毛みたいやつなの！

      それを、もふもふが好きな子が
      「おまもり」にしたり、「しおり」にしたり、
      いろんなものに変えるんだ♪

      今日はね、「ちゅうもん」がいっぱいで……
      ぽめ、ずーっとぱたぱたしてたの！
      だから夜ゴハンがいまからになっちゃったのね！

      なにたべようかな？
      がんばったから、豪華にお肉ミックスのカリカリ……？
      それともお野菜たっぷりのかんづめ……？ごくり……
    TEXT
  }
)

dinner_branch_b = upsert_conversation(
  code: "conv.greet.night.eat_together",
  attrs: {
    character_id: pomemaru.id,
    kind:         0,
    role:         1,
    time_slot:    :night,
    weather_slot: :any_weather,
    weight:       1,
    text: <<~TEXT
      えっ……%{nickname}しゃんと、いっしょごはん……！？

      ぽめ、それね、ずーっとやってみたかったの！
      おさらをならべて、「いただきます」って
      せーのでするやつなのね！

      ぽめはカリカリと、あったかミルクにしようかな。
      %{nickname}しゃんは、なに食べるの？
      ごはん？パン？それとも、おしゃれパスタとか……？
      想像しただけで、ぽめのおなかが、ぐ〜って鳴っちゃうの。

      いっしょに食べたらね、
      きっといつものカリカリも、いつものゴハンも、
      ぜんぶ“とくべつな夜ごはん”になるのね！

      じゃあぽめ、おさらもってくる！
      %{nickname}しゃん、ちょっとだけ待っててね？
      しっぽぶんぶんで、急いで戻ってくるから〜！
    TEXT
  }
)

upsert_choice(
  conversation:      dinner_greet,
  position:          1,
  label:             "今からゴハン？",
  next_conversation: dinner_branch_a
)

upsert_choice(
  conversation:      dinner_greet,
  position:          2,
  label:             "一緒に食べよ！",
  next_conversation: dinner_branch_b
)

puts "[seeds] greetings: done (greet_id=#{dinner_greet.id})"