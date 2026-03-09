class User < ApplicationRecord
  before_validation :normalize_nickname

  attr_accessor :terms
  before_save :stamp_terms_agreement, if: -> { terms.to_s == "1" && terms_agreed_at.blank? }

  validates :guest_uid, uniqueness: true, presence: true

  # ニックネーム（新規登録時エラーメッセージ）
  validates :nickname,
    presence: { message: "ニックネームを入力してね" },
    length: { maximum: 10, message: "ニックネームは10文字以内で入力してね" },
    on: :update

  validates :nickname,
    format: {
      with: /\A[[:alnum:]\p{Hiragana}\p{Katakana}\p{Han}\p{Zs}]+\z/u,
      message: "使用できない文字が含まれているよ"
    },
    allow_blank: true,
    on: :update

  # 地域（新規登録時エラーメッセージ）
  validates :region, presence: { message: "地域を選んでね" },on: :update

  # 規約チェック（新規登録時エラーメッセージ）
  validate :terms_must_be_agreed, on: :update

  # terms用メソッド１
  def terms_must_be_agreed
    return if terms_agreed_at.present?
    return if terms.to_s == "1"
    errors.add(:terms, "利用規約への同意が必要だよ")
  end

  # terms用メソッド２
  def stamp_terms_agreement
    self.terms_agreed_at = Time.current
    self.terms_version   = "2025-10-30"
  end

  # Rails標準のhas_secure_passwordを使用。
  # ゲストユーザーが存在するため、password必須バリデーションは条件付きで別途定義する。
  has_secure_password validations: false

  # email
  validates :email,
    presence: { message: "メールアドレスを入力してね" },
    format: { with: URI::MailTo::EMAIL_REGEXP, message: "メールアドレスの形式がちがうよ" },
    uniqueness: { case_sensitive: false, message: "このメールアドレスはすでに使われているよ" },
    on: :upgrade

  # password
  validates :password,
    presence: { message: "パスワードを入力してね" },
    length: { minimum: 8, message: "パスワードは8文字以上にしてね" },
    confirmation: { message: "パスワード（確認）が一致してないよ" },
    on: :upgrade

  # password_confirmation
  validates :password_confirmation,
    presence: { message: "確認用パスワードも入力してね" },
    on: :upgrade

  has_many :user_characters
  has_many :interactions
  has_many :inquiries
  has_many :mofu_diaries, dependent: :destroy

  # regionと同じenumの書き方だとエラー出るので、auth_kindのみ書き方変更しました
  enum :auth_kind, { guest: 0, password: 1 }, default: :guest, prefix: true

  enum region: {
    tokyo:   0,
    osaka:   1,
    nagoya:  2,
    sapporo: 3,
    fukuoka: 4
  }

  def region_coords
    case region&.to_sym
    when :tokyo
      { lat: 35.6812, lon: 139.7671 }  #東京駅
    when :osaka
      { lat: 34.7050, lon: 135.4984 }  #大阪梅田駅
    when :nagoya
      { lat: 35.1014, lon: 136.5253 }  #名古屋駅
    when :sapporo
      { lat: 43.0686, lon: 141.3507 }  #札幌駅
    when :fukuoka
      { lat: 33.5897, lon: 130.4205 }  #博多駅
    else
      # 万が一 enum が nil / 不正なときのデフォルト（東京）
      { lat: 35.6812, lon: 139.7671 }
    end
  end

  private

  def normalize_nickname
    return if nickname.nil?
    self.nickname = nickname.gsub(/\A([[:space:]\u3000])+|([[:space:]\u3000])+\z/u, "")
  end
end
