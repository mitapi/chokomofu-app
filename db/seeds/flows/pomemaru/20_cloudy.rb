#晴れ会話

puts "[seeds] any_cloudy_greet: start"  # ← デバッグ用ログ

pomemaru = Character.find_or_create_by!(key: "pomemaru") do |c|
  c.name = "ぽめまる"
end

DAY_SLOTS_01.each do |slot|
  any_cloudy_greet = upsert_conversation(
    code: "conv.any_cloudy_greet.#{slot}",
    attrs: {
      character_id: pomemaru.id,
      kind:         0,
      role:         0,
      time_slot:    slot,
      weather_slot: :cloudy,
      weight:       1,
      expression_keys: [
        "face_hmm",
        "face_smile",
        "face_happy",
        "face_kirakira"
      ].to_json,
      text: <<~TEXT
        きょうは雲さんもくもくなのね。
        雨、だいじょうぶかなあ……？

        今日ははおさんぽやめて、おうちでおしごとの続きするの。
        「ほしのけ」をふわふわまんまるにしていくのね。
        「ほしのけ」、キラキラでキレイでしょ～♪
        お空から落ちてくるんだけど、こないだいっぱい取れたのね！

        %{nickname}しゃんも欲しい？
        じゃあこの一番キラキラなの、ちっちゃいビンにつめてあげるの。
        ピンクのと、黄色のと、あと水色も入れてあげる！

        わあ……、けっこう、キレイに作れたとおもうの！
        あんまりお天気よくない日でも、これ見たらキラキラで元気出る……かも♪
        ぽめからのプレゼント、大事にしてくれたらうれしいの。
      TEXT
    }
  )
end