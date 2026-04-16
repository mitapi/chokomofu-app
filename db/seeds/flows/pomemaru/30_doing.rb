#今何してる？会話

puts "[seeds] pomemaru_doing: start"  # ← デバッグ用ログ

pomemaru = Character.find_or_create_by!(key: "pomemaru") do |c|
  c.name = "ぽめまる"
end

DAY_SLOTS_02.each do |slot|
  pomemaru_doing = upsert_conversation(
    code: "conv.pomemaru_doing.#{slot}",
    attrs: {
      character_id: pomemaru.id,
      kind:         0,
      role:         0,
      time_slot:    slot,
      weather_slot: :any_weather,
      weight:       1,
      expression_keys: [
        "face_happy"
      ].to_json,
      text: <<~TEXT
        %{nickname}しゃん、ぽめが来ましたよ♪
        いまなにしてるの～？
      TEXT
    }
  )

  pomemaru_doing_branch_a = upsert_conversation(
    code: "conv.pomemaru_doing.work.#{slot}",
    attrs: {
      character_id: pomemaru.id,
      kind:         0,
      role:         1,
      time_slot:    slot,
      weather_slot: :any_weather,
      weight:       1,
      expression_keys: [
        "face_kirakira",
        "face_happy",
        "face_happy",
        "face_hmm",
        "face_smile",
        "face_kirakira"
      ].to_json,
      text: <<~TEXT
        %{nickname}しゃん……とっても、えらいの～～っ！！！
        おしごと、たくさんがんばっているのね。

        毎日一生懸命な%{nickname}しゃん、とってもとってもスゴイのね。
        ぽめ、応援したくなっちゃうの。

        なにで応援しようかな。
        ポメ音頭とか、おどっちゃったり……？？

        ……え、おひざに乗ってほしいの？
        ほんとにそれでいいの～？

        あ、ぽめをモフモフしたいのね！
        ぽめ、ふわもこだから……ってコト♪

        ちょっと疲れちゃったら、いつでもモフモフしてもいいのね♪
        たまに頭とかなでてくれると、うれしいの。
      TEXT
    }
  )

  pomemaru_doing_branch_b = upsert_conversation(
    code: "conv.pomemaru_doing.rest.#{slot}",
    attrs: {
      character_id: pomemaru.id,
      kind:         0,
      role:         1,
      time_slot:    slot,
      weather_slot: :any_weather,
      weight:       1,
      expression_keys: [
        "face_smile",
        "face_sleepy",
        "face_surprise",
        "face_smile",
        "face_sleepy"
      ].to_json,
      text: <<~TEXT
        じゃあ、ぽめもいっしょに「きゅうけい」するの。
        %{nickname}しゃんのおひざに乗るのね。
        よいしょ、よいしょ。

        ……。
        ……。

        はっ、ちょっとうとうとしちゃったの！
        おひざ、すごーくいい感じのあたたかさなのね。
        ぽめ、このまんますやすやできちゃう、かも～。

        あ、なでなでもしてくれるの！
        あたまから背中への、なめらかな「撫で」……
        %{nickname}しゃんは、やっぱり「ポメ撫で検定１級」持ってる……のね……？？

        すや。
      TEXT
    }
  )

  pomemaru_doing_branch_c = upsert_conversation(
    code: "conv.pomemaru_doing.many.#{slot}",
    attrs: {
      character_id: pomemaru.id,
      kind:         0,
      role:         1,
      time_slot:    slot,
      weather_slot: :any_weather,
      weight:       1,
      expression_keys: [
        "face_hmm",
        "face_eat_02",
        "face_smile",
        "face_hmm",
        "face_happy",
        "face_smile"
      ].to_json,
      text: <<~TEXT
        いろいろなのね！
        お家のことしたり、おべんきょとか、お外出たり……とか？

        わからないけど、きっと今日はたくさんやることがあるのね。
        じゃあね、ぽめもついてって、おてつだいするのー！！

        えーっと、えっとね。
        たとえば、お部屋でゆかをふきふきしたり、横でえんぴつをけずったり、おさいふ係ができたりするの。

        えっ、それだとぽめが疲れちゃわないって？

        ううん。ぽめは%{nickname}しゃんといっしょに何かできるのが、とってもうれしいのね！
        遊ぶのも、おやつの時間もおてつだいも、ぜんぶすっごくたのしいの。

        じゃあまずは「けづくろい」して、おてつだいの準備するの。
        くしくし、くしくし……
      TEXT
    }
  )

  upsert_choice(
    conversation:      pomemaru_doing,
    position:          1,
    label:             "お仕事だよ",
    next_conversation: pomemaru_doing_branch_a
  )

  upsert_choice(
    conversation:      pomemaru_doing,
    position:          2,
    label:             "休憩中♪",
    next_conversation: pomemaru_doing_branch_b
  )

  upsert_choice(
    conversation:      pomemaru_doing,
    position:          3,
    label:             "いろいろ！",
    next_conversation: pomemaru_doing_branch_c
  )
end