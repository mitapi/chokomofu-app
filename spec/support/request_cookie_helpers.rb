module RequestCookieHelpers

  def set_cookie_string
    Array(response.headers["Set-Cookie"]).compact.join("\n")
  end

  # ---- set-cookieの値を取り出す---- 
  def extract_cookie_value(name)
    cookie_line = set_cookie_string.lines.find { |line| line.include?("#{name}=") }
    return nil unless cookie_line
  
    # "name=value; 他の属性" から "value" を取り出す
    cookie_line.split("#{name}=")[1]&.split(";")&.first&.strip
  end

  # ---- Set-Cookie に guest_uid=...という記述が含まれる---- 
  def contains_cookie_name?(name)
    set_cookie_string.present? && set_cookie_string.include?("#{name}=")
  end

  # ---- 初回cookie発行。Userを1行作成、Set-Cookie に guest_uid=... を含む---- 
  def issue_first_cookie
    expect { get main_path }.to change(User, :count).by(1)
    expect(response).to have_http_status(:ok)

    expect(contains_cookie_name?("guest_uid")).to be(true)

    # 署名付きトークン（次のリクエストで使う用）
    signed_token = extract_cookie_value("guest_uid")
    expect(signed_token).to be_present

    user = User.order(created_at: :desc).first
    expect(user).to be_present
    expect(user.guest_uid).to be_present
  end

  # ---- Set-Cookie に HttpOnly / SameSite=Lax を含んでいるか---- 
  # Secure は本番のみ付与方針なので、テストでは必須にしない
  def expect_cookie_attributes_for(name)
    cookie_line = set_cookie_string.downcase
    expect(cookie_line).to include("httponly")
    expect(cookie_line).to include("samesite=lax")
  end

  # ---- ブラウザのCookie保存”を再現するクッキージャー ----
  def ensure_cookie_jar!
    @cookie_pairs = {} unless @cookie_pairs.is_a?(Hash)
  end

  # ---- レスポンスの Set-Cookie を取り込む ---- 
  def carry_response_cookies!
    ensure_cookie_jar!
    Array(response.headers["Set-Cookie"]).compact.each do |line|
      # 先頭の name=value だけ（; 以降は属性なので捨てる）
      if (m = line.match(/\A([^=;,\s]+)=([^;,\s]+)/))
        name, val = m[1], m[2]
        @cookie_pairs[name] = val
      end
    end
  end

  # ---- 任意の Cookie を上書き（破損/改ざん再現） ---- 
  def set_cookie_pair(name, value)
    ensure_cookie_jar!
    @cookie_pairs[name] = value
  end

  # ---- クッキーの中身を削除 ---- 
  def delete_cookie_pair(name)
    ensure_cookie_jar!
    @cookie_pairs.delete(name)
  end

  # ---- クッキージャー内のcookieを、HTTPリクエストのCookie:ヘッダ文字列に変換 ---- 
  def next_request_headers
    @cookie_pairs = {} unless @cookie_pairs.is_a?(Hash)

    # nil の値は送らない（= 削除扱い）
    effective_pairs = @cookie_pairs.reject { |_, v| v.nil? }

    # "name=value; name2=value2" 形式に整形
    cookie_string = effective_pairs.map { |name, value| "#{name}=#{value}" }.join("; ")

    { "Cookie" => cookie_string }
  end
end
