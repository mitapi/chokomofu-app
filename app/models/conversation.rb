class Conversation < ApplicationRecord
  enum time_slot: {
    morning:    0,
    noon:       1,
    night:      2,
    late_night: 3,
    any:        4
  }, _default: :morning

  scope :for_slot, ->(slot) { where(time_slot: [slot, :any]) }
end
