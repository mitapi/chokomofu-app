#おひるごはん食べた？の会話
pomemaru = Character.find_or_create_by!(name: "ぽめまる")

lunch = Conversation.find_or_initialize_by(code: "conv.lunch.noon.main")
lunch.update!(
  character_id:  pomemaru.id,
  kind:          0,        # talk
  time_slot:     :noon,    # おひるの時間帯（enumに :noon がある前提）
  weather_slot:  0,        # any
  min_affinity:  0,
  weight:        1,
  text: <<~TEXT
    こんにちは、%{nickname}！
    もうおひるごはんは食べた？
  TEXT
)

# 分岐A：食べた場合
lunch_a = Conversation.find_or_initialize_by(code: "conv.lunch.noon.ate_lunch")
lunch_a.update!(
  character_id:  pomemaru.id,
  kind:          0,
  time_slot:     :noon,
  weather_slot:  0,
  min_affinity:  0,
  weight:        1,
  text: <<~TEXT
    いいね〜、%{nickname}！
    おひるをちゃんと食べると、午後もがんばれるよね。
  TEXT
)

# 分岐B：まだの場合
lunch_b = Conversation.find_or_initialize_by(code: "conv.lunch.noon.skipped_lunch")
lunch_b.update!(
  character_id:  pomemaru.id,
  kind:          0,
  time_slot:     :noon,
  weather_slot:  0,
  min_affinity:  0,
  weight:        1,
  text: <<~TEXT
    そっか、%{nickname}。
    おなかペコペコにならないように、
    休憩タイミングでちょこっとだけでも食べようね。
  TEXT
)

# ユーザー選択肢（ラベルにもニックネームを入れてみる）
choice1 = ConversationChoice.find_or_initialize_by(
  conversation_id: lunch.id,
  position:        1
)
choice1.update!(
  label:               "食べたよ！（%{nickname}）",
  next_conversation_id: lunch_a.id
)

choice2 = ConversationChoice.find_or_initialize_by(
  conversation_id: lunch.id,
  position:        2
)
choice2.update!(
  label:               "まだなんだ…（%{nickname}）",
  next_conversation_id: lunch_b.id
)
