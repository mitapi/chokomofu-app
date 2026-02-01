module ExpressionHelper
  def expressions_config
    # nil対策
    @expressions_config ||= Rails.application.config_for(:expressions) || {}
  end

  def expression_map_for(character)
    return {} if character.blank?

    char_key = character.key.to_s
    raw = expressions_config[char_key] || expressions_config[char_key.to_sym] || {}

    raw.each_with_object({}) do |(face_key, v), h|
      src =
        if v.is_a?(Hash)
          v["src"] || v[:src]
        else
          v
        end

      next if src.blank?
      h[face_key.to_s] = asset_path(src)
    end
  end

  def expression_width_map_for(character)
    return {} if character.blank?

    char_key = character.key.to_s
    raw = expressions_config[char_key] || expressions_config[char_key.to_sym] || {}

    raw.each_with_object({}) do |(face_key, v), h|
      next unless v.is_a?(Hash)
      w = v["width"] || v[:width]
      h[face_key.to_s] = w.to_i if w.present?
    end
  end

  def default_expression_src(character)
    map = expression_map_for(character)
    map["face_idle"] || map.values.first
  end
end