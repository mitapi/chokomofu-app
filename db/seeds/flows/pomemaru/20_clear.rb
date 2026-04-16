#晴れ会話

puts "[seeds] any_clear_greet: start"  # ← デバッグ用ログ

pomemaru = Character.find_or_create_by!(key: "pomemaru") do |c|
  c.name = "ぽめまる"
end

DAY_SLOTS_01.each do |slot|
  any_clear_greet = upsert_conversation(
    code: "conv.any_clear_greet.#{slot}",
    attrs: {
      character_id: pomemaru.id,
      kind:         0,
      role:         0,
      time_slot:    slot,
      weather_slot: :clear,
      weight:       1,
      expression_keys: [
        "face_kirakira",
        "face_kirakira",
        "face_smile",
        "face_happy",
        "face_kirakira"
      ].to_json,
      text: <<~TEXT
        きょう、おひさまだ～！！
        おそとも明るくて、おさんぽとか行きたくなっちゃう気分なのね。

        ぽめ、おさんぽ大好きなの♪
        %{nickname}しゃんも、いっしょにおさんぽ行く？
        きょうはあの、いっぱい走れるひろーい公園にしようかな。

        そこね、ぽめのおともだちもたくさん遊びにくるんだよ～！
        とっても広いから、ぽめたちにも大人気なの。

        %{nickname}しゃんも、ぽめといっしょにおさんぽ行こ♪
        ぽめのおともだちも、%{nickname}しゃんが来たら「こんにちは～」ってごあいさつしに来ると思うの。

        そだ、みんなで一緒にポール遊びとかもしちゃう……？？
        わくわく……！
      TEXT
    }
  )
end