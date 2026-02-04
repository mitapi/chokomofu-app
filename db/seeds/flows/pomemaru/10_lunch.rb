#昼ごはん食べた？の会話（ぽめまる）

puts "[seeds] lunch: start"  # ← デバッグ用ログ

pomemaru = Character.find_or_create_by!(name: "ぽめまる")

lunch_greet = upsert_conversation(
  code: "conv.greet.noon_01.lunch",
  attrs: {
    character_id: pomemaru.id,
    kind:         0,
    role:         0,
    time_slot:    :noon_01,
    weather_slot: :any_weather,
    weight:       1,
    text:         "%{nickname}しゃん、こんにちは〜！ お昼ゴハンは食べた？"
  }
)

lunch_branch_a = upsert_conversation(
  code: "conv.greet.noon_01.ate_lunch",
  attrs: {
    character_id: pomemaru.id,
    kind:         0,
    role:         1,
    time_slot:    :noon_01,
    weather_slot: :any_weather,
    weight:       1,
    text: <<~TEXT
      そなの！おなかいっぱいになった〜？
      ぽめは結構、おなかいっぱいなの。

      おひるゴハンはいつも、
      「食べすぎないように！」って思ってるんだけど
      いつもちょっと欲張っちゃうんだよね。

      えっ、%{nickname}しゃんもおなじなの？
      それ……ぽめとおそろいなの〜！！

      そうだっ、もし食べすぎておねむになっちゃったら、
      ぽめが“ふみふみ”して起こしてあげるの！
      うどんをふみっ……ふみっ……ってするように、ね♪
    TEXT
  }
)

lunch_branch_b = upsert_conversation(
  code: "conv.greet.noon_01.skipped_lunch",
  attrs: {
    character_id: pomemaru.id,
    kind:         0,
    role:         1,
    time_slot:    :noon_01,
    weather_slot: :any_weather,
    weight:       1,
    text: <<~TEXT
      食べてないの……！おなか、すいちゃうよね。
      ぐーって音も鳴っちゃうし……

      そだ！ぽめは考えまちた。
      おなかが鳴りそうになったら、
      ぽめが「ワン！」って鳴いてごまかしてあげるの！
      おなかの音なんて、いっかいでどっかいっちゃうんだから！

      ……でもね、たまにぽめのおなかも
      いっしょに「ぐ〜」って鳴っちゃうの……

      そのときは、%{nickname}しゃんも
      いっしょに「ワン！」してほしいのね！
    TEXT
  }
)

upsert_choice(
  conversation:      lunch_greet,
  position:          1,
  label:             "食べたよー！",
  next_conversation: lunch_branch_a
)

upsert_choice(
  conversation:      lunch_greet,
  position:          2,
  label:             "食べられなかった……",
  next_conversation: lunch_branch_b
)

puts "[seeds] greetings: done (greet_id=#{lunch_greet.id})"