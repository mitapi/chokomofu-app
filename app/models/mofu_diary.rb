class MofuDiary < ApplicationRecord
  before_validation :ensure_share_token, on: :create
  belongs_to :user

  validates :date, presence: true
  validates :line1, presence: true
  validates :line2, presence: true

  validates :date, uniqueness: { scope: :user_id }
  validates :share_token, presence: true, uniqueness: true

  enum :time_slot, {
    any: 0,
    morning: 1,
    noon_01: 2,
    noon_02: 3,
    evening: 4,
    night: 5,
    late_night: 6,
    early_morning: 7
  }, default: :morning

  enum :weather_slot, {
    any_weather: 0,
    clear: 1,
    cloudy: 2,
    rain: 3,
    snow: 4
  }, default: :any_weather

  private

  def ensure_share_token
    self.share_token ||= SecureRandom.urlsafe_base64(12)
  end
end




