class Conversation < ApplicationRecord
  belongs_to :character
  has_many :conversation_choices

  enum time_slot: {
    morning:    0,
    noon:       1,
    night:      2,
    late_night: 3,
    any:        4
  }, _default: :morning

  enum weather_slot: {
    any:   0,
    clear: 1,
    cloudy: 2,
    rain:  3,
    snow:  4
  }, _default: :any

  scope :for_slot,    ->(slot)    { where(time_slot: [slot, :any]) }
  scope :for_weather, ->(w_slot)  { where(weather_slot: [w_slot, :any]) }
end
