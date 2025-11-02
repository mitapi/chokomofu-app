# なぜかdevelopmentでテスト実行されるので、以下のコマンドで実行する。
# docker compose exec -e RAILS_ENV=test web bundle exec rspec spec/requests/nicknames_spec.rb

require "rails_helper"
require "nokogiri"

RSpec.describe "Nicknames", type: :request do
  # ↓で、developmentで実行されているのでテストが403で通らないことに気づきました
  puts "[SPEC DEBUG] hosts=#{Rails.application.config.hosts.inspect} env=#{Rails.env}"

  it "nickname更新の際にユーザーは増えない" do
    host! "www.example.com" 
    # 編集画面にGETして CSRFトークン取得
    get edit_nickname_path
    expect(response).to have_http_status(:ok)

    doc   = Nokogiri::HTML.parse(response.body)
    token = doc.at('input[name="authenticity_token"]')&.[]('value') ||
            doc.at('meta[name="csrf-token"]')&.[]('content')

    user = User.order(created_at: :desc).first || User.create!(guest_uid: SecureRandom.uuid, auth_kind: :guest)

    expect {
      patch nickname_path, params: {
        authenticity_token: token,
        user:  { nickname: "ぽめ" },
        terms: "1"
      }
    }.not_to change(User, :count)

    expect(response).to redirect_to(main_path)
    expect(user.reload.nickname).to eq("ぽめ")
  end
end