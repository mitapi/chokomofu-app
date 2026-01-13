class Interaction < ApplicationRecord
  belongs_to :user
  belongs_to :character

  enum kind: {
    snack: 0,
    toy: 1
  }

  enum snack_type: {
    cookie: 0,
    jerky: 1
  }
end
