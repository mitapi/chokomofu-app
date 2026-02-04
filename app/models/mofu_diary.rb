class MofuDiary < ApplicationRecord
  belongs_to :user

  validates :date, presence: true
  validates :line1, presence: true
  validates :line2, presence: true

  validates :date, uniqueness: { scope: :user_id }
end