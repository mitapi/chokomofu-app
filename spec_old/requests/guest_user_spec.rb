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
      expect_cookie_attributes_for(response.headers["Set-Cookie"])
    end

    it "debug: /main 初回で Set-Cookie が出て User が 1 増える" do
      puts "[DBG-env] #{Rails.env}"
      puts "[DBG-hosts] #{Rails.application.config.hosts.inspect}"

      expect {
        get main_path, headers: { "HOST" => "www.example.com" }  # ← 明示指定
        puts "[DBG-status] #{response.status}"
        puts "[DBG-set-cookie] #{response.headers['Set-Cookie'].inspect}"
        puts "[DBG-body] #{response.body&.slice(0, 200)}" # "Blocked host:" が出るはず
      }.to change { User.count }.by(1)
    end
  end

  describe "再訪（正常）" do
    it "同日アクセスで User.count は増えない" do
      issue_first_cookie
      carry_response_cookies!
      user_before = User.order(created_at: :desc).first
      expect(user_before).to be_present

      # 同日アクセスで User.count は増えない
      expect{ get path, headers: next_request_headers}.not_to change{ User.count }

      user_after = User.order(created_at: :desc).first
      expect(user_after.id).to eq(user_before.id)
    end
  end

  describe "Cookie破損（署名不一致 / 形式不正）" do
    context "別データがあり再取得できる場合（例：セッションに user_id がある）" do
      it "User.count は増えず、同一レコードを継続する" do
        # 1) 初回（正常）: Cookie配布 & 既存ユーザーを記録
        issue_first_cookie
        carry_response_cookies!
        user_before = User.order(created_at: :desc).first
        expect(user_before).to be_present

        # 2) guest_uid を破損させる（ただしセッションには user_id を入れておく）
        set_cookie_pair("guest_uid", "NOT-A-VALID-TOKEN")

        # 3) 再訪: 同一ユーザーを復旧（+0）
        expect { get path, headers: headers }.not_to change { User.count }
        expect(response).to have_http_status(:ok)

        # 同一レコードであること
        user_after = User.order(created_at: :desc).first
        expect(user_after.id).to eq(user_before.id)
      end
    end

    context "別データが無く再取得できない場合" do
      it "User.count は +1、新しい匿名ユーザーを作成する" do
        # 1) 初回（正常）
        issue_first_cookie
        carry_response_cookies!
        user_before = User.order(created_at: :desc).first

        # 2) guest_uid を破損させ、セッション/補助cookieも消す
        delete_cookie_pair("_app_session")
        delete_cookie_pair("guest_uid_refreshed_on")
        set_cookie_pair("guest_uid", "NOT-A-VALID-TOKEN")

        # 3) 再訪: 安全フォールバックで新規作成（+1）
        expect {
          p [:next_headers, next_request_headers]  # ← デバッグ用（送るヘッダを確認）
          get path, headers: next_request_headers
        }.to change { User.count }.by(1)
        expect(response).to have_http_status(:ok)

        # 末尾が新規で、UUID形式が入っていることだけ確認
        user_after = User.order(created_at: :desc).first
        expect(user_after.id).not_to eq(user_before.id)
        expect(user_after.guest_uid).to match(/\A[0-9a-f\-]{36}\z/i)
      end
    end
  end

  describe "D) DB欠損（Cookie正常だが行が消えた）" do
    it "同じUIDでUserを再作成して復旧する" do
      uid = issue_first_cookie
      carry_response_cookies!
      user = User.order(created_at: :desc).first

      # DB欠損を手動で作る
      User.where(guest_uid: uid).delete_all
      expect(User.find_by(guest_uid: uid)).to be_nil

      # 同じCookieで再訪
      set_cookie_pair("guest_uid", uid)
      expect{ get path, headers: next_request_headers}.to change{ User.count }.by(1) 
      expect(response).to have_http_status(:ok)
      expect(user).to be_present

      # 日次更新（Cookie再発行）を同時にテストしないように
      expect(contains_cookie_name?("guest_uid")).to be(false)
    end
  end

  # describe "E) 日次更新（JST 0:00 跨ぎ）" do
    # it "当日中は未更新・翌日になったらSet-Cookieで更新する" do
end