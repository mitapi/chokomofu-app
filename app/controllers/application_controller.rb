class ApplicationController < ActionController::Base
  before_action :ensure_current_user

  COOKIE_NAME = :guest_uid
  COOKIE_REFRESH_MARKER = :guest_uid_refreshed_on
  COOKIE_MAX_AGE_DAYS = 180
  UUID_REGEX = /\A[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}\z/i

  private
  def ensure_current_user

  end

  # 値が空でなく、UUIDの正規表現にマッチするかを返す
  def uuid_valid?(uid)
    uid.present? && uid.match?UUID_REGEX
  end

  # 署名付きCookieから guest_uid を読む。「署名不正」などで例外が出たら ログ1行＋nil を返す。（処理は継続させる）
  def read_signed_uid
    cookies.signed[COOKIE_NAME]
  rescue
    Rails.logger.info(event: "cookie_invalid_signature", action: "issued_new_uid", path: request.path, request_id: request.request_id)
    nil
  end

  def write_signed_uid(uid, expires_at: COOKIE_MAX_AGE_DAYS.days.from_now)

  end
end
