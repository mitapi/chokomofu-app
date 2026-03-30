#新しいおもちゃの会話

puts "[seeds] pomemaru_play: start"  # ← デバッグ用ログ

pomemaru = Character.find_or_create_by!(key: "pomemaru") do |c|
  c.name = "ぽめまる"
end

DAY_SLOTS_04.each do |slot|
  pomemaru_play = upsert_conversation(
    code: "conv.pomemaru_play.#{slot}",
    attrs: {
      character_id: pomemaru.id,
      kind:         0,
      role:         0,
      time_slot:    slot,
      weather_slot: :any_weather,
      weight:       1,
      expression_keys: [
        "face_hmm
      ].to_json,
      text: <<~TEXT
        ねえねえ、%{nickname}しゃん。
        これなあに～？ぽめのあたらしいおもちゃ？
      TEXT
    }
  )

  pomemaru_play_branch_a = upsert_conversation(
    code: "conv.pomemaru_play.ball.#{slot}",
    attrs: {
      character_id: pomemaru.id,
      kind:         0,
      role:         1,
      time_slot:    slot,
      weather_slot: :any_weather,
      weight:       1,
      expression_keys: [
        "face_kirakira",
        "face_surprise",
        "face_idle",
        "face_kirakira",
        "face_smile"
      ].to_json,
      text: <<~TEXT
        あたらしいボールだ～！！
        %{nickname}しゃん、ありがとうなの～！！

        あ！転がってっちゃったの。
        まてまて～！！まてまて～！！

        はあ、はあ。
        ……%{nickname}しゃん、ぽめ、気づいちゃいました。

        これって……
        「無限にあそべちゃうヤツ」、なんじゃない……！？？
        ボール遊び、ぽめだけでも楽しすぎちゃうのね！

        でも、あとで%{nickname}しゃんも一緒にあそんでくれたらもっと楽しいのね。
        ボール、ぽめが追いかける？それとも%{nickname}しゃんが追いかけたい？？
      TEXT
    }
  )

  pomemaru_play_branch_b = upsert_conversation(
    code: "conv.pomemaru_play.sound.#{slot}",
    attrs: {
      character_id: pomemaru.id,
      kind:         0,
      role:         1,
      time_slot:    slot,
      weather_slot: :any_weather,
      weight:       1,
      expression_keys: [
        "face_hmm",
        "face_smile",
        "face_smile"
      ].to_json,
      text: <<~TEXT
        %{nickname}しゃん、これ、ぷい！ぷい！て音がするの。
        中にだれかはいってるの～？
        でも、ぺしょってなるから多分いないのね。
        
        えへへ、ぷいぷい言うのかわいいの。
        おともだちのもるもるちゃんも、楽しくなると「ぷ！」て言うのね♪

        このぬいぐるみさん、よく見るともるもるちゃんに似てる気もする……？
        もしかしてこのぬいぐるみさんは、ぽめのおともだちを見て作ったのかなあ。
        %{nickname}しゃんは、どう思う～？
      TEXT
    }
  )

  upsert_choice(
    conversation:      pomemaru_play,
    position:          1,
    label:             "ボールだよ～",
    next_conversation: pomemaru_play_branch_a
  )

  upsert_choice(
    conversation:      pomemaru_play,
    position:          2,
    label:             "音の鳴るぬいぐるみ！",
    next_conversation: pomemaru_play_branch_b
  )
end