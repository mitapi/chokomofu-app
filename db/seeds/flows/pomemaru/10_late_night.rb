#眠くなってきた～の会話（ぽめまる）

puts "[seeds] late_night: start"  # ← デバッグ用ログ

pomemaru = Character.find_or_create_by!(name: "ぽめまる")

late_night_greet = upsert_conversation(
  code: "conv.greet.late_night.sleepy",
  attrs: {
    character_id: pomemaru.id,
    kind:         0,
    role:         0,
    time_slot:    :late_night,
    weather_slot: :any_weather,
    min_affinity: 0,
    weight:       1,
    text: <<~TEXT        
      ふわわ～……はっ！
      えへへ、ぽめ、ちょっとねむくなってきちゃったの。
      おめめが、しょぼしょぼしてるのね……。

      %{nickname}しゃんは、もうおやすみする？
      それとも、まだ起きてるの？
    TEXT
  }
)

late_night_branch_a = upsert_conversation(
  code: "conv.greet.late_night.sleep_together",
  attrs: {
    character_id: pomemaru.id,
    kind:         0,
    role:         1,
    time_slot:    :late_night,
    weather_slot: :any_weather,
    min_affinity: 0,
    weight:       1,
    text: <<~TEXT
      うん……いっしょに寝たいな。
      %{nickname}しゃん、ぽめもおふとんに入れてほしいの。
      
      このおふとん、ふわふわで気持ちいい～。
      じゃあ、ぽめはこのへんでまるくなって寝るのね。

      %{nickname}しゃん、おやすみなの。
      またあした、いっぱいおはなししようね。
    TEXT
  }
)

late_night_branch_b = upsert_conversation(
  code: "conv.greet.late_night.pome_sleep",
  attrs: {
    character_id: pomemaru.id,
    kind:         0,
    role:         1,
    time_slot:    :late_night,
    weather_slot: :any_weather,
    min_affinity: 0,
    weight:       1,
    text: <<~TEXT
      そなのね、じゃあぽめは……
      このへんで、まるくなっておやすみしてるの。

      もしね、ぽめがそのまま寝ちゃったら
      %{nickname}しゃんが寝るときに、
      ぽめを一緒のおふとんに入れてほしいのね。

      %{nickname}しゃんが近くにいたら、
      ぽめ、あんしんしてねれると思うの。
      だからね……むにゃ。
    TEXT
  }
)

upsert_choice(
  conversation:      late_night_greet,
  position:          1,
  label:             "一緒に寝ようかな",
  next_conversation: late_night_branch_a
)

upsert_choice(
  conversation:      late_night_greet,
  position:          2,
  label:             "まだ起きてるよ",
  next_conversation: late_night_branch_b
)

puts "[seeds] greetings: done (greet_id=#{late_night_greet.id})"