class ApplicationController < ActionController::Base
  before_action :ensure_current_user
  helper_method :current_user, :text

  COOKIE_NAME = :guest_uid
  COOKIE_REFRESH_MARKER = :guest_uid_refreshed_on
  COOKIE_MAX_AGE_DAYS = 180
  UUID_REGEX = /\A[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}\z/i

  private

  def ensure_current_user
    uid = read_signed_uid
    Rails.logger.debug(event: "whoami_current_uid", uid: uid) if Rails.env.development?

    if !uuid_valid?(uid)
      uid = SecureRandom.uuid
      Rails.logger.info(event: "cookie_missing_or_invalid", action: "issued_new_uid", path: request.path, request_id: request.request_id)
    end

    user = User.find_by(guest_uid: uid)
    unless user
    user = User.create!(guest_uid: uid, auth_kind: :guest)
    Rails.logger.info(event: "user_missing_in_db", action: "recreated_user", path: request.path, request_id: request.request_id)
    end

    refresh_cookie_once_per_day(uid)
    @current_user = user

  rescue => e
    uid = SecureRandom.uuid
    user = User.create!(guest_uid: uid, auth_kind: :guest)
    write_signed_uid(uid)
    @current_user = user
    Rails.logger.warn(event: "ensure_current_user_rescued", error: e.class.name, path: request.path, request_id: request.request_id)
  end

  def current_user
    @current_user
  end

  # 値が空でなく、UUIDの正規表現にマッチするかを返す
  def uuid_valid?(uid)
    uid.present? && uid.match?(UUID_REGEX)
  end

  # 署名付きCookieから guest_uid を読む。「署名不正」などで例外が出たら ログ1行＋nil を返す。（処理は継続させる）
  def read_signed_uid
    cookies.signed[COOKIE_NAME]
  rescue
    Rails.logger.info(event: "cookie_invalid_signature", action: "issued_new_uid", path: request.path, request_id: request.request_id)
    nil
  end

  # 署名付きCookieに uid を保存（期限や属性も付与）
  def write_signed_uid(uid, expires_at: COOKIE_MAX_AGE_DAYS.days.from_now)
    cookies.signed[COOKIE_NAME] = {
      value: uid,
      httponly: true,
      same_site: :lax,
      secure: Rails.env.production?,
      expires: expires_at
    }
  end

  # 1日1回、ログインごとにスライド延長しましたというコメントを残す
  def refresh_cookie_once_per_day(uid)
    today = Time.zone.today.iso8601
    if cookies[COOKIE_REFRESH_MARKER]!= today
      write_signed_uid(uid)
      cookies[COOKIE_REFRESH_MARKER] = {
        value: today,
        httponly: true,
        same_site: :lax,
        secure: Rails.env.production?,
        expires: 2.days.from_now
      }
    end
  end

  def current_weather_slot
    coords = current_user.region_coords
    result = Weather::FetchCurrentWeather.new(
      lat: coords[:lat],
      lon: coords[:lon]
    ).call

    result.slot

  rescue => e
    Rails.logger.error(event: "current_weather_slot_failed", error: e.message)
    :any
  end

  # nicknameとtermsがあれば/mainへ
  def onboarding_completed?
    current_user.nickname.present? && current_user.terms_agreed_at.present? && current_user.region.present?
  end

  def redirect_if_onboarding_completed
    Rails.logger.info("[onboarding] redirect_if_onboarding_completed path=#{request.path} completed=#{onboarding_completed?}")
    return if controller_name == "welcomes" && action_name == "guide"
    redirect_to main_path if onboarding_completed?
  end

  def redirect_unless_onboarding_completed
    redirect_to welcome_path unless onboarding_completed?
  end
end
