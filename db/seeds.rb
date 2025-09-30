ActiveRecord::Base.transaction do
  pomemaru = Character.find_or_create_by!(name: "ぽめまる")

  greet = Conversation.find_or_initialize_by(code: "conv.greet.morning.breakfast")
  greet.update!(
    character_id: pomemaru.id,
    kind: 0,          # talk
    time_slot: :any,
    weather_slot: 0,  # any
    min_affinity: 0,
    weight: 1,
    text: "おはよ～、朝ゴハンは食べた？"
  )

  #選択肢タップ後、分岐会話
  branch_a = Conversation.find_or_initialize_by(code: "conv.greet.morning.ate_breakfast")
  branch_a.update!(
    character_id: pomemaru.id,
    kind: 0, time_slot: :any, weather_slot: 0, min_affinity: 0, weight: 1,
    text: <<~TEXT
      一日のはじまりは朝ゴハンだよね。
      ぽめもね、カリカリを食べたんだよ！
    TEXT
  )

  branch_b = Conversation.find_or_initialize_by(code: "conv.greet.morning.skipped_breakfast")
  branch_b.update!(
    character_id: pomemaru.id,
    kind: 0, time_slot: :any, weather_slot: 0, min_affinity: 0, weight: 1,
    text: <<~TEXT
      そうなの！
      おなかが空かないように、ぽめが兵糧丸を分けてあげるからね！
    TEXT
  )

  #ユーザー選択肢
  choice1 = ConversationChoice.find_or_initialize_by(
    conversation_id: greet.id, position: 1
  )
  choice1.update!(label: "食べたよ", next_conversation_id: branch_a.id)

  choice2 = ConversationChoice.find_or_initialize_by(
    conversation_id: greet.id, position: 2
  )
  choice2.update!(label: "食べてないんだ", next_conversation_id: branch_b.id)

  puts "[seeds] OK: character=#{pomemaru.id}, greet=#{greet.id}, branches=[#{branch_a.id}, #{branch_b.id}]"
end
