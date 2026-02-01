class Character < ApplicationRecord
  validates :key, presence: true, uniqueness: true,
                  format: { with: /\A[a-z0-9_]+\z/ }
end
