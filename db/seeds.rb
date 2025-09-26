ActiveRecord::Base.transaction do
  pomemaru = Character.find_or_create_by!(name: "ぽめまる")

  greet = Conversation.find_or_initialize_by(code: "conv.greet.morning.breakfast")
  greet.update!(
    character_id: pomemaru.id,
    kind: 0,          # talk
    time_slot: 0,     # morning
    weather_slot: 0,  # any
    min_affinity: 0,
    weight: 1,
    text: "おはようでしゅ！朝ゴハンはたべまちたか？"
  )

  #選択肢タップ後、分岐会話
  branch_a = Conversation.find_or_initialize_by(code: "conv.greet.morning.ate_breakfast")
  branch_a.update!(
    character_id: pomemaru.id,
    kind: 0, time_slot: 0, weather_slot: 0, min_affinity: 0, weight: 1,
    text: "一日のはじまりは朝ゴハンでしゅよね。ぽめも、カリカリを食べまちた！"
  )

  branch_b = Conversation.find_or_initialize_by(code: "conv.greet.morning.skipped_breakfast")
  branch_b.update!(
    character_id: pomemaru.id,
    kind: 0, time_slot: 0, weather_slot: 0, min_affinity: 0, weight: 1,
    text: "そうなの！おなかが空かないように、ぽめが兵糧丸を分けてあげるね"
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
