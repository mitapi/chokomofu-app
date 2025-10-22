class User < ApplicationRecord
  validates :guest_uid, uniqueness: true, presence: true
  # validates :nickname,
            # presence: true,
            # length: { maximum: 30 },
            # unless: :guest?

  has_many :user_characters
  has_many :interactions
  has_many :inquiries

  enum auth_kind: {
    guest:     0,
    password:  1,
  }, _default: :guest 
end
