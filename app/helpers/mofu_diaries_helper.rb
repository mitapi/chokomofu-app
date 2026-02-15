module MofuDiariesHelper
  def diary_illust_image_path(diary)
    illust = diary.illust.presence || "nomal"

    # もふ日記画像
    case illust
    when "nomal"
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
  end

  # もふ日記天気スタンプ
  def weather_stamp_path(weather_slot)
    map = {
      "clear"  => "stamp/weather_clear.png",
      "cloudy" => "stamp/weather_cloudy.png",
      "rain"   => "stamp/weather_rain.png",
      "snow"   => "stamp/weather_snow.png"
    }
    map[weather_slot.to_s]
  end
end