#ぽめまる就寝中会話２（ぽめまる）

puts "[seeds] early_morning_02: start"  # ← デバッグ用ログ

pomemaru = Character.find_or_create_by!(key: "pomemaru") do |c|
  c.name = "ぽめまる"
end

early_morning_02_greet = upsert_conversation(
  code: "conv.greet.early_morning_02.sleeping",
  attrs: {
    character_id: pomemaru.id,
    kind:         0,
    role:         0,
    time_slot:    :early_morning,
    weather_slot: :any_weather,
    weight:       1,
    expression_keys: [
      "face_in_bed",
      "face_in_bed",
      "face_in_bed"
    ].to_json,
    text: <<~TEXT
      ……むにゃむにゃ、もう、たべられないの～。
      まだこんなに……おいしい、おやつ……
      ちゃむ、ちゃむ……

      ちゃむ……

      （ぽめまるは夢の中で、おやつを食べているみたい。
      明日、おやつを持ってきてあげようかな。）
    TEXT
  }
)