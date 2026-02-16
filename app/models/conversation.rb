class Conversation < ApplicationRecord
  belongs_to :character
  has_many :conversation_choices

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
    any:   0,
    clear: 1,
    cloudy: 2,
    rain:  3,
    snow:  4
  }, default: :any

  enum :kind, { talk: 0, whisper: 1 }, prefix: true

  # entry: 0（/chatの会話導入。選択肢あり/なしどっちもOK）/followup: 1（会話分岐後）
  enum :role, { entry: 0, followup: 1 }, prefix: true

  scope :for_slot,    ->(slot)    { where(time_slot: [slot, :any]) }
  scope :for_weather, ->(w_slot)  { where(weather_slot: [w_slot, :any]) }
end
