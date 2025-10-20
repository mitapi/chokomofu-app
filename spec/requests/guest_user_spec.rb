require 'rails_helper'

RSpec.describe "Anonymous Guest Cookie (guest_uid)", type: :request do
  include ActiveSupport::Testing::TimeHelpers
  include RequestCookieHelpers
  let(:path) { main_path }

  describe "初回訪問（Cookieなし）" do
    it "新規発行(Set-Cookie)" do
      # Userを1行作成、Set-Cookie に guest_uid=... を含む
      uid = issue_first_cookie

      # Set-Cookie に HttpOnly / SameSite=Lax を含んでいる" do
      expect_cookie_attributes(response.headers["Set-Cookie"])
    end
  end

  describe "再訪（正常）" do
    it "同日アクセスで User.count は増えない、uid再発行はしない" do
      uid = issue_first_cookie

      # 同日アクセスで User.count は増えない
      set_next_request_cookie("guest_uid", uid)
      expect{ get path, headers: next_request_headers}.not_to change{ User.count }

      # 原則、同日中は再発行しない（= Set-Cookie に guest_uid を含まない）
      expect(contains_cookie_name?("guest_uid")).to be(false)
      # ↓は guest_uid は含まれていないけど、DBにはユーザーがちゃんと存在しているかをチェックしています
      expect(User.find_by(uid: uid)).to be_present
    end
  end

  describe "Cookie破損（署名不一致 / 形式不正）" do
    it "安全に再発行し、必要ならUserを再作成/再取得する" do
      @next_cookie_header = "guest_uid=this-is-not-a-uuid"
      before_count = User.count

      # 不正なuidを受け取ってもエラーで落ちない
      get path, headers: next_request_headers
      expect(response).to have_http_status(:ok)

      # 新しいuidを再発行する
      expect(contains_cookie_name?("guest_uid")).to be(true)
      new_uid = extract_cookie_value("guest_uid")
      expect(new_uid).to be_present
      expect(User.find_by(guest_uid: new_uid)).to be_present

      # 二重発行していないか？
      set_cookie = response.headers["Set-Cookie"]
      expect(set_cookie.scan("guest_uid=").size).to eq(1)

      # データがあって再取得の場合は増えないし、データがなければ新規作成される（ので、>=にしています）
      expect(User.count).to be >= before_count
    end
  end

  describe "D) DB欠損（Cookie正常だが行が消えた）" do
    it "同じUIDでUserを再作成して復旧する" do
      uid = issue_first_cookie
      # DB欠損を手動で作る
      User.where(guest_uid: uid).delete_all
      expect(User.find_by(guest_uid: new_uid)).to be_nil

      # 同じCookieで再訪
      set_next_request_cookie("guest_uid", uid)
      expect{ get path, headers: next_request_headers}.to change{ User.count }.by(1) 
      expect(response).to have_http_status(:ok)
      expect(user_by(uid)).to be_present

      # 日次更新（Cookie再発行）を同時にテストしないように
      expect(contains_cookie_name?("guest_uid")).to be(false)
    end
  end

  # describe "E) 日次更新（JST 0:00 跨ぎ）" do
    # it "当日中は未更新・翌日になったらSet-Cookieで更新する" do
end