require "net/http"
require "json"

class Weather::FetchCurrentWeather
  Result = Struct.new(:slot, keyword_init: true)

  def initialize(lat:, lon:)
    @lat = lat
    @lon = lon
  end

  def call
    data = Rails.cache.fetch(cache_key, expires_in: 30.minutes) do  #(注１)
      fetch_from_api
    end
    
    Result.new(slot: map_weather_slot(data))

  rescue => e
    Rails.logger.error(event: "weather_fetch_failed", error: e.message)
    Result.new(slot: :any_weather)
  end

  private

  #キャッシュキー生成
  def cache_key
    rounded_lat = @lat.round(2)
    rounded_lon = @lon.round(2)
    "weather:#{rounded_lat}:#{rounded_lon}"
  end

  #Open-Meteo のURLを組み立てて、HTTPで取りに行く
  def fetch_from_api
    url = URI::HTTPS.build(
      host: "api.open-meteo.com",
      path: "/v1/forecast",
      query: URI.encode_www_form(
        latitude:  @lat,
        longitude: @lon,
        current:   "weather_code",
        timezone:  "auto"
      )
    )

    response = Net::HTTP.get_response(url)

    unless response.is_a?(Net::HTTPSuccess)
      Rails.logger.error(
        event: "weather_api_http_error",
        code:  response.code,
        body:  response.body
      )
      return nil
    end

    JSON.parse(response.body, symbolize_names: true)
  end

  #天気コード → アプリの区分に変換
  def map_weather_slot(data)
    return :any_weather unless data

    code = extract_weather_code(data)

    case code
    when 0
      :clear
    when 1, 2, 3
      :cloudy
    when 51, 53, 55, 61, 63, 65, 80, 81, 82
      :rain
    when 71, 73, 75, 77, 85, 86
      :snow
    else
      :any_weather
    end
  end

  #Open-Meteo のレスポンスの中から、天気コードを取り出す
  def extract_weather_code(data)
    data.dig(:current, :weather_code)
  end
end


#注１……cache_key でキャッシュを探す。
#あればそれを data に入れ、なければ fetch_from_api を実行して、その結果をキャッシュ＆data に入れる