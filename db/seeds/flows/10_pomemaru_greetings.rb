#朝ごはん食べた？の会話（ぽめまる）

puts "[seeds] greetings: start"  # ← デバッグ用ログ

pomemaru = Character.find_or_create_by!(name: "ぽめまる")

greet = upsert_conversation(
  code: "conv.greet.morning.breakfast",
  attrs: {
    character_id: pomemaru.id,
    kind:         0,          # talk
    time_slot:    :any,
    weather_slot: :any_weather,
    min_affinity: 0,
    weight:       1,
    text:         "%{nickname}しゃん、おはよ～！もう朝ゴハン、食べた？"
  }
)

branch_a = upsert_conversation(
  code: "conv.greet.morning.ate_breakfast",
  attrs: {
    character_id: pomemaru.id,
    kind:         0,
    time_slot:    :any,
    weather_slot: :any_weather,
    min_affinity: 0,
    weight:       1,
    text: <<~TEXT
      一日の始まりは、やっぱり朝ゴハンだよね♪
      ぽめもね、カリカリを食べたの！

      カリカリにはときどき“あたり”が入ってるんだけど、
      今日はなんと！ハートのかたちのカリカリが出たんだよ～！

      %{nickname}しゃんは、なに食べたの？
      おむすびかな、それともふかふかのパン……？
      ぽめもいつか人間のゴハンってやつ、食べてみたいな〜
    TEXT
  }
)

branch_b = upsert_conversation(
  code: "conv.greet.morning.skipped_breakfast",
  attrs: {
    character_id: pomemaru.id,
    kind:         0,
    time_slot:    :any,
    weather_slot: :any_weather,
    min_affinity: 0,
    weight:       1,
    text: <<~TEXT
      そなの！おなか空いちゃわない……？
      おなかが空いても大丈夫なように、ぽめの兵糧丸、分けてあげるの！

      ぽめの兵糧丸はね、ウェットフードとミルクを
      こね、こね、こね〜ってして作ってるの！
      ぎゅっ…て握ってあるから、小さくてもおなかいっぱいになるんだよ♪

      %{nickname}しゃん、ちょっと味見してみる？
      えっ、いらないの？
      むむむ……このおいしさは、人間にはちょっと早すぎたのかも……？
    TEXT
  }
)

upsert_choice(
  conversation:      greet,
  position:          1,
  label:             "食べたよ！",
  next_conversation: branch_a
)

upsert_choice(
  conversation:      greet,
  position:          2,
  label:             "食べてないんだ",
  next_conversation: branch_b
)

puts "[seeds] greetings: done (greet_id=#{greet.id})"