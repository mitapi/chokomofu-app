#歌を歌うぽめまる会話

puts "[seeds] pomemaru_singing: start"  # ← デバッグ用ログ

pomemaru = Character.find_or_create_by!(key: "pomemaru") do |c|
  c.name = "ぽめまる"
end

DAY_SLOTS_01.each do |slot|
  pomemaru_singing = upsert_conversation(
    code: "conv.pomemaru.singing",
    attrs: {
      character_id: pomemaru.id,
      kind:         0,
      role:         0,
      time_slot:    slot,
      weather_slot: :any_weather,
      weight:       1,
      expression_keys: [
        "face_smile",
        "face_surprise",
        "face_kirakira",
        "face_happy",
        "face_happy"
      ].to_json,
      text: <<~TEXT
        ぽ・ぽめめ♪ぽめ♪
        ぽめめぽ～めぽめ♪ぽ・め♪

        あ！もしかして、今の……聞こえてた？

        これ、最近すっごく人気の「お歌」なの！
        ぽめ、じょうずに歌えてたでしょ～？

        じつはダンスもあるんだけど、途中までおぼえたの。
        しっぽふりふり、おてて上げて、みぎ、ひだり……

        （ぽめまるは一生懸命にステップを踏んでいる。
        ダンシングポメラニアンとしての素質が花開くときがくる……のかもしれない。）

      TEXT
    }
  )
end