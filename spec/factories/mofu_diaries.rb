FactoryBot.define do
  factory :mofu_diary do
    user { nil }
    date { "2026-02-03" }
    title { "MyString" }
    line1 { "MyString" }
    line2 { "MyString" }
    weather_slot { 1 }
    time_slot { 1 }
    character_key { "MyString" }
  end
end
