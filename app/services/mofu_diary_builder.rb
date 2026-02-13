class MofuDiaryBuilder
  Result = Struct.new(
    :line1, :line2, :illust, :weather_slot, :time_slot, :character_key,
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

    # 日記文章とイラスト出し分けのためのカテゴリ
    category =
      if snack_count.zero? && talk_count.zero?
        :rest
      elsif talk_count.zero? && snack_count <= 2
        :snack_light
      elsif talk_count.zero? && snack_count >= 3
        :snack_heavy
      elsif snack_count.zero? && talk_count <= 4
        :talk_light
      elsif snack_count.zero? && talk_count >= 5
        :talk_heavy
      elsif snack_count <= 2 && talk_count <= 4
        :both_light
      else
        :both_heavy
      end

    # イラスト出し分け（★イラスト作る！）
    illust =
      case category
      when :rest        then "idle"
      when :snack_light then "snack_light"
      when :snack_heavy then "snack_heavy"
      when :talk_light  then "talk_light"
      when :talk_heavy  then "talk_heavy"
      when :both_light  then "snack_talk_light"
      when :both_heavy  then "snack_talk_heavy"
      end

    # 文章は「2行固定」でテンプレ出し分け（MVP）
    line1, line2 =
      if snack_count.zero? && talk_count.zero?
        ["きょうは ゆっくり ひとやすみデー。", "もふもふなでなで、してもらったよ♪"]
      elsif talk_count.zero? && snack_count <= 2
        ["おいしい おやつを もらったよ。", "もっと たくさん、たべたい おいしさ……♪"]
      elsif talk_count.zero? && snack_count >= 3
        ["ちょこっと おしゃべり。", "おはなしできて、とっても うれしい～！"]
      elsif snack_count.zero? && talk_count <= 4
        ["たくさん おやつを もらえちゃった！", "おなか いっぱい、しあわせ～♪"]
      elsif snack_count.zero? && talk_count >= 5
        ["きょうは いっぱい おしゃべりデー！", "あしたも たくさん おしゃべり したいな♪ わくわく。"]
      elsif snack_count <= 2 && talk_count <= 4
        ["おやつを たべて、おしゃべりも したよ！", "たのしいこと たくさん、うれしいきもち♪"]
      else
        ["おやついっぱい、おしゃべりもいっぱい！！", "さいこうすぎて、もふもふが さらに もふもふに なる～♪"]
      end

    Result.new(
      line1: line1,
      line2: line2,
      illust: illust,
      weather_slot: 0,   # ここは後で既存の天気スロットを差し込む
      time_slot: 0,      # ここも後で
      character_key: "pomemaru"
    )
  end
end