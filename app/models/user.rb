class User < ApplicationRecord
  before_validation :normalize_nickname

  validates :guest_uid, uniqueness: true, presence: true
  validates :nickname, length: { maximum: 10 }, allow_blank: true

  has_many :user_characters
  has_many :interactions
  has_many :inquiries

  enum :auth_kind, {
    guest:     0,
    password:  1,
  }, default: :guest 

   enum :region, {
    tokyo:   0,
    osaka:   1,
    nagoya:  2,
    sapporo: 3,
    fukuoka: 4
  }

  def region_coords
    case region&.to_sym
    when :tokyo
      { lat: 35.6812, lon: 139.7671 }  #東京駅
    when :osaka
      { lat: 34.7050, lon: 135.4984 }  #大阪梅田駅
    when :nagoya
      { lat: 35.1014, lon: 136.5253 }  #名古屋駅
    when :sapporo
      { lat: 43.0686, lon: 141.3507 }  #札幌駅
    when :fukuoka
      { lat: 33.5897, lon: 130.4205 }  #博多駅
    else
      # 万が一 enum が nil / 不正なときのデフォルト（東京）
      { lat: 35.6812, lon: 139.7671 }
    end
  end

  private

  def normalize_nickname
    return if nickname.nil?
    self.nickname = nickname.gsub(/\A([[:space:]\u3000])+|([[:space:]\u3000])+\z/u, "")
  end
end
