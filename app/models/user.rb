class User < ApplicationRecord
<<<<<<< HEAD
  validates :guest_uid, uniqueness: true, presence: true
  # validates :nickname,
            # presence: true,
            # length: { maximum: 30 },
            # unless: :guest?
=======
  before_validation :normalize_nickname

  validates :guest_uid, uniqueness: true, presence: true
  validates :nickname, length: { maximum: 10 }, allow_blank: true
>>>>>>> nrc_backup

  has_many :user_characters
  has_many :interactions
  has_many :inquiries

  enum auth_kind: {
    guest:     0,
    password:  1,
  }, _default: :guest 
<<<<<<< HEAD
end
=======

  private

  def normalize_nickname
    return if nickname.nil?
    self.nickname = nickname.gsub(/\A([[:space:]\u3000])+|([[:space:]\u3000])+\z/u, "")
  end
end
>>>>>>> nrc_backup
