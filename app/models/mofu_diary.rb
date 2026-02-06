class MofuDiary < ApplicationRecord
  before_validation :ensure_share_token, on: :create
  belongs_to :user

  validates :date, presence: true
  validates :line1, presence: true
  validates :line2, presence: true

  validates :date, uniqueness: { scope: :user_id }
  validates :share_token, presence: true, uniqueness: true

  private

  def ensure_share_token
    self.share_token ||= SecureRandom.urlsafe_base64(12)
  end
end




