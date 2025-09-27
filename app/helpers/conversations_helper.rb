module ConversationsHelper
  REGISTRY = {
    "pomemaru" => {
      allowed: %i[idle smile wink],
      map: {
        "ate_breakfast"     => :smile,
        "skipped_breakfast" => :wink
      }
    }
  }.freeze

  DEFAULT_ALLOWED = %i[idle].freeze
  DEFAULT_MAP     = {}.freeze

  CHAR_DIR_BY_NAME = {
    "ぽめまる" => "pomemaru"
  }.freeze

  def character_dir_for(character)
    CHAR_DIR_BY_NAME[character.name] || character.name.to_s.parameterize
  end

  def expression_for(conversation, character_dir: "pomemaru")
    cfg = REGISTRY[character_dir] || {}
    allowed = Array(cfg[:allowed] || DEFAULT_ALLOWED)
    suffix_map = cfg[:map] || DEFAULT_MAP

    code = conversation&.code.to_s
    # ↓デバッグして、code内のドットを.splitが上手く認識できてないみたいなので.split(/[^[:alnum:]_]+/)に変更
    last = code.split(/[^[:alnum:]_]+/).last

    return last.to_sym if last && allowed.include?(last.to_sym)
    return suffix_map[last] if suffix_map.key?(last)

    :idle
  end

  def expression_image_path(character_dir: "pomemaru", expression: :idle)
    "character/#{character_dir}/#{expression}.png"
  end
end
