#夜会話02（ぽめまる）

puts "[seeds] late_night_02: start"  # ← デバッグ用ログ

pomemaru = Character.find_or_create_by!(key: "pomemaru") do |c|
  c.name = "ぽめまる"
end

late_night_02_greet = upsert_conversation(
  code: "conv.late_night_02_greet",
  attrs: {
    character_id: pomemaru.id,
    kind:         0,
    role:         0,
    time_slot:    :late_night,
    weather_slot: :any_weather,
    weight:       1,
    expression_keys: [
      "face_smile",
      "face_hmm",
      "face_smile"
    ].to_json,
    text: <<~TEXT
      あのね、あのね。
      %{nickname}しゃん、今日もぽめといっしょにいてくれて、ありがとうなの。

      急にどうしたのって？
      ん～、どうもしないけど、言いたくなっちゃったの。

      明日もまた、ぽめといっぱいおしゃべりしようね。
      おやつもいっしょに食べて、そのあとおひざにのせてほしいな。
    TEXT
  }
)