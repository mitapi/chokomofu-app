module RequestCookieHelpers

  # set-cookieの値を取り出す
  def extract_cookie_value(name)
    set_cookie = responce.headers["Set-Cookie"]
    return nil unless set_cookie
    m = set_cookie.match(/#{Regexp.escape(name)=([^;]+)}/)
    m && m[1]
    # m は配列ではなく、Rubyの MatchData オブジェクト。m[1]は、([^;]+)の部分。
  end

  # Set-Cookie に guest_uid=...という記述が含まれる
  def contains_cookie_name?(name)
    set_cookie = response.headers["Set-Cookie"]
    !!(set_cookie && set_cookie.include?("#{name}="))
  end

  # 初回cookie発行。Userを1行作成、Set-Cookie に guest_uid=... を含む
  def issue_first_cookie
    expect{ get main_path }.to change{ User.count }.by(1) 
    expect(response).to have_http_status(:ok) 

    expect(contains_cookie_name?("guest_uid")).to be(true)
    uid = extract_cookie_value("guest_uid")

    # guest_uidが空ではないか
    expect(uid).to be_present

    # guest_uidに対応するユーザーは存在しているか
    expect(User.find_by(guest_uid: uid)).to be_present
    return uid
  end

  # Set-Cookie に HttpOnly / SameSite=Lax を含んでいるか
  # Secure は本番のみ付与方針なので、テストでは必須にしない
  def expect_cookie_attributes(set_cookie_string)
    expect(set_cookie_string).to include("HttpOnly")
    expect(set_cookie_string).to include("SameSite=Lax")
  end

  # 次に送るHTTPリクエストに Cookie を含める準備をする
  def set_next_request_cookie(name, value)
    @next_cookie_header = "#{name}=#{value}"
  end

  # 次のHTTPリクエストで送信するヘッダーを準備する
  def next_request_headers
    if @next_cookie_header
      { "Cookie" => @next_cookie_header }
    else
      {}
    end
  end
end
