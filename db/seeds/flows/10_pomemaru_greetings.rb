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
    text:         "%{nickname}、おはよ～！朝ゴハンは食べた？"
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
      一日のはじまりは朝ゴハンだよね。
      ぽめもね、カリカリを食べたんだよ！
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
      そうなの！
      おなかが空かないように、ぽめが兵糧丸を分けてあげるからね！
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