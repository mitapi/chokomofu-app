require "mini_magick"

class OgImageGenerator
  WIDTH  = 1200
  HEIGHT = 630

  def initialize(diary)
    @diary = diary
  end

  def generate_to!(path)
    MiniMagick::Tool.new("convert") do |c|
      c.size "#{WIDTH}x#{HEIGHT}"
      c << "xc:white"
      c << path.to_s
    end

    image = MiniMagick::Image.open(path.to_s)

    # 2) ぽめまる合成（ファイルがあれば）
    illust_path = absolute_illust_path(@diary.illust)
    if illust_path && File.exist?(illust_path)
      char = MiniMagick::Image.open(illust_path)
      char.resize "520x520"

      image = image.composite(char) do |c|
        c.gravity "West"
        c.geometry "+80+0"
      end
    end

    # 3) 2行テキスト（まずは英数字でもOK、日本語が□なら次でフォント指定）
    #line1 = escape_for_draw(@diary.line1.to_s)
    #line2 = escape_for_draw(@diary.line2.to_s)

    #image.combine_options do |c|
      #c.font font_path if font_path # ← これが肝
      #c.fill "black"
      #c.pointsize "48"
      #c.gravity "SouthWest"
      #c.draw "text 80,170 '#{line1}'"
      #c.draw "text 80,110 '#{line2}'"
    #end

    image.write(path.to_s)
    path
  end

  def generate
    Tempfile.create(["og_mofu_diary_#{@diary.id}_", ".png"]) do |f|
      generate_to!(f.path)
      File.binread(f.path)
    end
  end

  private

  def absolute_illust_path(illust)
    rel =
      case (illust.presence || "normal")
      when "normal"
        "diary/pomemaru_nomal.png"
      when "snack_light"
        "diary/pomemaru_snack_light.png"
      when "snack_heavy"
        "diary/pomemaru_snack_heavy.png"
      when "talk_light"
        "diary/pomemaru_talk_light.png"
      when "talk_heavy"
        "diary/pomemaru_talk_heavy.png"
      when "snack_talk_light"
        "diary/pomemaru_snack_talk_light.png"
      else
        "diary/pomemaru_snack_talk_heavy.png"
      end

    Rails.root.join("public", "ogp", rel).to_s
  end

  def escape_for_draw(str)
    str.gsub("\\", "\\\\").gsub("'", "\\\\'")
  end

  def font_path
    candidates = [
      "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
      "/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf",
      "/usr/share/fonts/truetype/liberation/LiberationSans-Regular.ttf"
    ]
    candidates.find { |p| File.exist?(p) }
  end
end