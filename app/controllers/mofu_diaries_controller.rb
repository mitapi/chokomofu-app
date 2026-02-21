class MofuDiariesController < ApplicationController
  skip_before_action :ensure_current_user, only: [:share, :og]

  def show
    @mofu_diary = current_user.mofu_diaries.find(params[:id])
  end

  def create_today
    today = Time.zone.today
    @mofu_diary = current_user.mofu_diaries.find_or_initialize_by(date: today)

    if @mofu_diary.new_record?
      built = MofuDiaryBuilder.new(
        user: current_user,
        date: today,
        weather_slot: current_weather_slot
      ).build

      @mofu_diary.assign_attributes(
        title: "#{today.strftime('%-m/%-d')} のもふ日記",
        line1: built.line1,
        line2: built.line2,
        weather_slot: built.weather_slot,
        time_slot: built.time_slot,
        character_key: built.character_key,
        illust: built.illust
      )
      @mofu_diary.save!
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to mofu_diary_path(@mofu_diary) }
   end
  end

  def confirm_today
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to main_path }
    end
  end

  def share
    @mofu_diary = MofuDiary.find_by!(share_token: params[:token])

    dir  = Rails.root.join("tmp", "og_mofu_diaries")
    FileUtils.mkdir_p(dir)

    # 「更新されたら別ファイル」方式でキャッシュを安定させる
    stamp = @mofu_diary.updated_at.to_i
    path  = dir.join("mofu_diary_#{@mofu_diary.id}_#{stamp}.png")

    OgImageGenerator.new(@mofu_diary).generate_to!(path) unless File.exist?(path)
  end

  def og
    diary = MofuDiary.find_by!(share_token: params[:share_token])

    dir  = Rails.root.join("tmp", "og_mofu_diaries")
    FileUtils.mkdir_p(dir)
    path = dir.join("mofu_diary_#{diary.id}.png")

    # 画像ファイルが無ければ生成（都度生成しない）
    OgImageGenerator.new(diary).generate_to!(path) unless File.exist?(path)

    # X(Twitterbot)向け：一度取れた画像を長くキャッシュしてもらう
    expires_in 1.year, public: true
    response.headers["Cache-Control"] = "public, max-age=31536000, immutable"
    response.headers["Content-Disposition"] = 'inline; filename="og.png"'

    # HEAD/GETどちらも send_file に任せる（Content-Length / Content-Type も任せる）
    send_file path, type: "image/png", disposition: "inline"
  end
end

#日記の文章・画像出し分けチェック（railsコンソール）
#user = User.last
#today = Time.zone.today
#user.mofu_diaries.where(date: today).destroy_all
#↑で、今日の日記を消す→作り直す、で確認する。