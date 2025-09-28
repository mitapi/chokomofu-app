class Conversation < ApplicationRecord
  enum time_slot: {
    morning:    0,
    noon:       1,
    night:      2,
    late_night: 3
  }, _default: :morning
end
