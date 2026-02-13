module MofuDiariesHelper
  def diary_illust_image_path(diary)
    illust = diary.illust.presence || "nomal"

    # 画像仮で入れています
    case illust
    when "snack"
      "diary/pomemaru_snack03.png"
    when "talk"
      "diary/pomemaru_talk03.png"
    else
      "diary/pomemaru_nomal.png"
    end
  end

  def weather_stamp_path(weather_slot)
    map = {
      "any_weather" => "stamp/weather_clear.png",
      "clear"       => "stamp/weather_clear.png",
      "cloudy"      => "stamp/weather_cloudy.png",
      "rain"        => "stamp/weather_rain.png",
      "snow"        => "stamp/weather_snow.png"
    }
    map[weather_slot.to_s]
  end
end