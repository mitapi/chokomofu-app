#ぽめまる就寝中、な会話（ぽめまる）

puts "[seeds] early_morning: start"  # ← デバッグ用ログ

pomemaru = Character.find_or_create_by!(name: "ぽめまる")

early_morning_greet = upsert_conversation(
  code: "conv.greet.early_morning.sleeping",
  attrs: {
    character_id: pomemaru.id,
    kind:         0,
    role:         0,
    time_slot:    :early_morning,
    weather_slot: :any_weather,
    min_affinity: 0,
    weight:       1,
    text: <<~TEXT
      すや……むにゃ……
    TEXT
  }
)

early_morning_branch_a = upsert_conversation(
  code: "conv.greet.early_morning.let_sleep",
  attrs: {
    character_id: pomemaru.id,
    kind:         0,
    role:         0,
    time_slot:    :early_morning,
    weather_slot: :any_weather,
    min_affinity: 0,
    weight:       1,
    text: <<~TEXT
      ぽめまるは気持ちよさそうに眠っています。
      まるくなって寝ている姿は、まるでわたあめのようです……
    TEXT
  }
)

early_morning_branch_b = upsert_conversation(
  code: "conv.greet.early_morning.dreaming",
  attrs: {
    character_id: pomemaru.id,
    kind:         0,
    role:         0,
    time_slot:    :early_morning,
    weather_slot: :any_weather,
    min_affinity: 0,
    weight:       1,
    text: <<~TEXT
      むにゃ……きょうのカリカリは、
      ミックスベジタブル味……てコト……？

      ちゃむ……ちゃむ……むにゃ……
    TEXT
  }
)

upsert_choice(
  conversation:      early_morning_greet,
  position:          1,
  label:             "そっとしておこう",
  next_conversation: early_morning_branch_a
)

upsert_choice(
  conversation:      early_morning_greet,
  position:          2,
  label:             "夢でも見てるのかな",
  next_conversation: early_morning_branch_b
)

puts "[seeds] greetings: done (greet_id=#{early_morning_greet.id})"