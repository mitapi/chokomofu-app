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
    line1 = escape_for_draw(@diary.line1.to_s)
    line2 = escape_for_draw(@diary.line2.to_s)

    image.combine_options do |c|
      c.font font_path if font_path # ← これが肝
      c.fill "black"
      c.pointsize "48"
      c.gravity "SouthWest"
      c.draw "text 80,170 '#{line1}'"
      c.draw "text 80,110 '#{line2}'"
    end

    image.write(path.to_s)
    path
  end

  private

  def absolute_illust_path(illust)
    rel =
      case (illust.presence || "idle")
      when "snack" then "diary/pomemaru_snack03.png"
      when "talk"  then "diary/pomemaru_talk03.png"
      else              "diary/pomemaru_nomal.png"
      end

    Rails.root.join("app/assets/images", rel).to_s
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