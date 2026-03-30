#雨会話（ぽめまる）

puts "[seeds] any_rain_greet: start"  # ← デバッグ用ログ

pomemaru = Character.find_or_create_by!(key: "pomemaru") do |c|
  c.name = "ぽめまる"
end

DAY_SLOTS_02.each do |slot|
  any_rain_greet = upsert_conversation(
    code: "conv.any_rain_greet.#{slot}",
    attrs: {
      character_id: pomemaru.id,
      kind:         0,
      role:         0,
      time_slot:    slot,
      weather_slot: :rain,
      weight:       1,
      expression_keys: [
        "face_hmm"
      ].to_json,
      text: <<~TEXT
        きょうは雨の日なのね。
        ぽめの毛も、なんだか元気ないの。
        %{nickname}しゃんの元気も、しょんぼりしてる……？
      TEXT
    }
  )

  any_rain_greet_branch_a = upsert_conversation(
    code: "conv.any_rain_greet.nomal.#{slot}",
    attrs: {
      character_id: pomemaru.id,
      kind:         0,
      role:         1,
      time_slot:    slot,
      weather_slot: :rain,
      weight:       1,
      expression_keys: [
        "face_surprise",
        "face_sleepy",
        "face_surprise",
        "face_kirakira"
      ].to_json,
      text: <<~TEXT
        そうなのっ！？
        %{nickname}しゃん、雨にも負けないつよつよさんなのね！

        ぽめはもう、ふかふかの毛がしっとりぺっしょりで……
        おひさまがとっても恋しいのね。

        ！！
        そ、そのブラシは……！？？
        もしかして、ぽめが湿っちゃってるから「ブラッシング」してくれるってコト……！？

        ぽめ、ブラッシングだいすきなの～！
        さ、さ♪ どぞどぞ♪
        えへへ、雨の日もたまには悪くないのね。
      TEXT
    }
  )

  any_rain_greet_branch_b = upsert_conversation(
    code: "conv.any_rain_greet.unwell.#{slot}",
    attrs: {
      character_id: pomemaru.id,
      kind:         0,
      role:         1,
      time_slot:    slot,
      weather_slot: :rain,
      weight:       1,
      expression_keys: [
        "face_idle",
        "face_eat_02",
        "face_hmm",
        "face_smile",
        "face_happy"
      ].to_json,
      text: <<~TEXT
        そうだよねえ……
        人間さんは、雨の日になると「ずつう」とか、気持ちも「うーん」ってなるって聞いたことあるの。
        ぽめ、なにかしてあげたいの……

        そだ！
        ぽめ、%{nickname}しゃんをよし、よし、とするのね。
        あたまは届かないから、おひざをよし、よしするの。

        え、いつのまにか「ふみ、ふみ」になってる……？？

        えへへ、ついつい。
        ぽめ、おててが小さいから、いつの間にかふみふみになっちゃうのね。

        ……これ、マッサージみたいで結構きもちいい？ほんと～！？
        ぽめもなんだかふみふみのリズムにのってきていい感じなの。
        ふみふみ♪ ふみ♪ ふみ♪
      TEXT
    }
  )

  upsert_choice(
    conversation:      any_rain_greet,
    position:          1,
    label:             "意外と大丈夫！",
    next_conversation: any_rain_greet_branch_a
  )

  upsert_choice(
    conversation:      any_rain_greet,
    position:          2,
    label:             "しょんぼりだよ～",
    next_conversation: any_rain_greet_branch_b
  )
end