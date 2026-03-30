#おやつぽめまる会話

puts "[seeds] pomemaru_snack: start"  # ← デバッグ用ログ

pomemaru = Character.find_or_create_by!(key: "pomemaru") do |c|
  c.name = "ぽめまる"
end

DAY_SLOTS_03.each do |slot|
  pomemaru_snack = upsert_conversation(
    code: "conv.pomemaru.snack.#{slot}",
    attrs: {
      character_id: pomemaru.id,
      kind:         0,
      role:         0,
      time_slot:    slot,
      weather_slot: :any_weather,
      weight:       1,
      expression_keys: [
        "face_happy",
        "face_happy",
        "face_kirakira",
        "face_smile",
        "face_smile"
      ].to_json,
      text: <<~TEXT
        %{nickname}しゃ～ん！！
        えへへ……ぽめ、とっておきの「おやつ」を持ってきちゃいました！

        じゃーん！
        ちっちゃいクッキー！！

        えっ、ふつうのクッキーでしょって？
        のんのん、実はこれ……
        にんげんさんも、ぽめも食べられるクッキーなんだよ～！！

        ぽめね、%{nickname}しゃんとおんなじものを、いつか食べてみたかったの。
        きょうのデザートは、ぽめといっしょにコレ食べようね♪

        そだ、ミルクもわすれずに、なのね！
        ミルクとクッキー、ぜったいにおいしい組み合わせ……なの！
      TEXT
    }
  )
end