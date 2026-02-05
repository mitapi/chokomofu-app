class MofuDiaryBuilder
  Result = Struct.new(
    :line1, :line2, :pose, :weather_slot, :time_slot, :character_key,
    keyword_init: true
  )

  def initialize(user:, date: Time.zone.today)
    @user = user
    @date = date
  end

  def build
    range = @date.beginning_of_day..@date.end_of_day

    base = @user.interactions.where(happened_at: range)

    snack_count = base.where(kind: :snack).count
    talk_count  = base.where(kind: :talk).count

    pose =
      if snack_count > talk_count
        "snack"
      elsif talk_count > snack_count
        "talk"
      else
        "idle"
      end

    # 文章は「2行固定」でテンプレ出し分け（MVP）
    line1, line2 =
      if snack_count.zero? && talk_count.zero?
        ["きょうは ひとやすみ したよ", "ゆっくり もふもふ 🐾"]
      elsif snack_count >= 3
        ["おやつを #{snack_count} かい もらったよ", "おなか いっぱい もふ〜"]
      elsif talk_count >= 3
        ["たくさん おしゃべり したよ", "きいてくれて ありがとう 🐶"]
      else
        ["おやつ: #{snack_count} / おしゃべり: #{talk_count}", "きょうも えらいぞ〜 🐾"]
      end

    Result.new(
      line1: line1,
      line2: line2,
      pose: pose,
      weather_slot: 0,   # ここは後で既存の天気スロットを差し込む
      time_slot: 0,      # ここも後で
      character_key: "pomemaru"
    )
  end
end