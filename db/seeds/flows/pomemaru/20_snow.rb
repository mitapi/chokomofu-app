#雨会話（ぽめまる）

puts "[seeds] any_snow_greet: start"  # ← デバッグ用ログ

pomemaru = Character.find_or_create_by!(key: "pomemaru") do |c|
  c.name = "ぽめまる"
end

DAY_SLOTS_02.each do |slot|
  any_snow_greet = upsert_conversation(
    code: "conv.any_snow_greet.#{slot}",
    attrs: {
      character_id: pomemaru.id,
      kind:         0,
      role:         0,
      time_slot:    slot,
      weather_slot: :swow,
      weight:       1,
      expression_keys: [
        "face_smile"
      ].to_json,
      text: <<~TEXT
        %{nickname}しゃん！みて、雪がふってるのー！！
        まっしろふわふわ……まるでぽめのよう、なのね。
        おみみのついた、ちっちゃいポメ雪だるまとか作りたいの。
      TEXT
    }
  )

  any_snow_greet_branch_a = upsert_conversation(
    code: "conv.any_snow_greet.create.#{slot}",
    attrs: {
      character_id: pomemaru.id,
      kind:         0,
      role:         1,
      time_slot:    slot,
      weather_slot: :snow,
      weight:       1,
      expression_keys: [
        "face_kirakira",
        "face_smile",
        "face_happy",
        "face_kirakira"
      ].to_json,
      text: <<~TEXT
        %{nickname}しゃん、一緒につくってくれるの～！
        じゃあ、ぽめね、すごーく大きいのをつくりたいな♪

        ぽめ３匹ぶんくらいのがいいかも。
        それでね、できたら上に乗って、おしゃしんとか撮りたいの！

        でもぽめ、いちばん上までは届かないから……
        %{nickname}しゃんがだっこしてほしいのね。

        だっこしてもらったら、ぽめが雪だるまさんのおみみとか付けてあげられるの！
        あ、飾りとかもあるとかわいい……？？
        そだ、ぽめのお帽子もってきて、雪だるまさんにのせてあげるのね♪
      TEXT
    }
  )

  any_snow_greet_branch_b = upsert_conversation(
    code: "conv.any_snow_greet.watch_over.#{slot}",
    attrs: {
      character_id: pomemaru.id,
      kind:         0,
      role:         1,
      time_slot:    slot,
      weather_slot: :snow,
      weight:       1,
      expression_keys: [
        "face_happy",
        "face_smile",
        "face_smile",
        "face_kirakira"
      ].to_json,
      text: <<~TEXT
        うん！
        じゃあぽめ、すごくかわいい雪だるまさんを%{nickname}しゃんに作ってあげるの。

        おみみつけて、おめめはまあるい木の実で作るの。
        おてては木の枝ひろってきて……
        あと、かわいいお帽子とか乗せてあげたり♪

        うん、なんだかかわいく作れそうな気がするの！
        じょうずにできたら、雪だるまさんと、ぽめと%{nickname}しゃんで、おしゃしん撮ろうね♪
        
        あたまにグーしたおててを持ってきて、「ポメみみポーズ」で撮るの～！
        雪だるまさんにもおみみを付けるから、ぽめたちもおそろいポーズにするの。
        どう？どう？
      TEXT
    }
  )

  upsert_choice(
    conversation:      any_snow_greet,
    position:          1,
    label:             "一緒に作ろう！",
    next_conversation: any_snow_greet_branch_a
  )

  upsert_choice(
    conversation:      any_snow_greet,
    position:          2,
    label:             "作るの見ててあげるね",
    next_conversation: any_snow_greet_branch_b
  )
end