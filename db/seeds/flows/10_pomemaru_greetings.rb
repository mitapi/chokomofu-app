pomemaru = Character.find_or_create_by!(name: "ぽめまる")

greet = upsert_conversation(
  code: "conv.greet.morning.breakfast",
  attrs:{
    character_id: pomemaru.id,
    kind: 0,          # talk
    time_slot: :any,
    weather_slot: 0,  # any
    min_affinity: 0,
    weight: 1,
    text: "おはよ～、朝ゴハンは食べた？"
  }
)

#選択肢タップ後、分岐会話
branch_a = upsert_conversation(
  code: "conv.greet.morning.ate_breakfast",
  attrs:{
    character_id: pomemaru.id,
    kind: 0, time_slot: :any, weather_slot: 0, min_affinity: 0, weight: 1,
    text: <<~TEXT
      一日のはじまりは朝ゴハンだよね。
      ぽめもね、カリカリを食べたんだよ！
    TEXT
  }
)

branch_b =  upsert_conversation(
  code: "conv.greet.morning.skipped_breakfast",
  attrs:{
    character_id: pomemaru.id,
    kind: 0, time_slot: :any, weather_slot: 0, min_affinity: 0, weight: 1,
    text: <<~TEXT
      そうなの！
      おなかが空かないように、ぽめが兵糧丸を分けてあげるからね！
    TEXT
  }
)

#選択肢
choice1 = upsert_choice(
  conversation_id: greet.id, position: 1,
  label: "食べたよ！", next_conversation: branch_a.id
)

choice2 = upsert_choice(
  conversation_id: greet.id, position: 2,
  label: "食べてないんだ", next_conversation_id: branch_b.id
)