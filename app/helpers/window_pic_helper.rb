module WindowPicHelper
  def background_slot_for(time_slot)
    case time_slot.to_sym
    when :morning, :noon_01, :noon_02
      :morning_noon
    when :evening
      :evening
    when :night, :late_night, :early_morning
      :night
    else
      :morning_noon
    end
  end

  def window_image_path(weather_slot:, time_slot:)
    bg_slot = background_slot_for(time_slot)
    "window/#{weather_slot}-#{bg_slot}.png"
  end
end
