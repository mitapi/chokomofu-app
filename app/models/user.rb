class User < ApplicationRecord
  before_validation :normalize_nickname

  validates :guest_uid, uniqueness: true, presence: true
  validates :nickname,
    length: { maximum: 10, message: "ニックネームは10文字以内で入力してください" },
    format:   {
      # ひらがな・カタカナ・漢字・英数字・スペース（全/半角）のみ許可。絵文字や記号は不許可
      with: /\A[[:alnum:]\p{Hiragana}\p{Katakana}\p{Han}\p{Zs}]+\z/u,
      message: "使用できない文字が含まれています"
    },
    allow_nil: true,
    allow_blank: true

  has_many :user_characters
  has_many :interactions
  has_many :inquiries

  enum auth_kind: {
    guest:     0,
    password:  1,
  }, _default: :guest 

  private

  def normalize_nickname
    return if nickname.nil?
    self.nickname = nickname.gsub(/\A([[:space:]\u3000])+|([[:space:]\u3000])+\z/u, "")
  end
end