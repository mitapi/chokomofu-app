このドキュメントは、
「Xでカードが出ない」「OGP画像が表示されない」
といった問題が発生した時のための確認メモです。

### ✅何が起きていたか（症状）

ブラウザやラッコツールでは OGP（meta と og.png）が確認できるのに、Xではカード自体が出ないことがある。

一度出ないと、投稿し直しても出ない／たまに出る、みたいに挙動がぶれる。


### ✅原因（本質）

**絶対URLでなく、相対URLを使っていた**
app/views/mofu_diaries/share.html.erb で、メタタグに絶対URLを使っていなかったことが原因でした。
ただ絶対URLを使っても挙動ブレは発生していたので、今回は念のためすべてのメタタグを書いて対策しました。


**Xから見て「ログイン用の動的ページっぽかった」**

X（Twitterbot）は、リンクを見つけると
「このページは、みんなに公開されている普通のページかな？」
とチェックします。

でも今回の share ページは、Xから見るとこう見えていた可能性が高い：

🍪 Cookie が付いていた（＝ログイン関係の情報がある）
🔒 Cache-Control: private（＝個人向けページっぽい）
🔄 Vary: Accept（＝見る人によって内容が変わる可能性あり）

つまり X から見ると、
「これ、ログインユーザー用のページじゃない？」
「人によって内容変わるページかも？」
と判断されやすい状態でした。

その結果、
meta タグは正しくても
「カードにするのやめておこう」と判断される
→ カードが出ない

ということが起きていました。

・・・・・・・・・・

⭐補足：
Xが「このページはログイン用・個人用かもしれない」と判断すると、
安全のためカード化をやめることがあるようです。

たとえるなら
静的ページ …… 公園の看板（誰でも見れる！）
→ カード出す

動的ログインページ風 …… マンションの部屋の中（住人専用かも）
→ カード出さない

今回、私の作成したshareページは
● Set-Cookieあり
● private cache
● セッションあり

だったので「Xから見ると、住人専用ページっぽい」
→ カード生成しない
ということに繋がったのだと思います。


### ✅解決のためにやってみたこと

**1) セッションを使わないようにした**
request.session_options[:skip] = true

↑ これを share / og に入れました。

これで：
● Cookie を出さない
● ログイン情報を書き込まない

＝ X から見ると
「あ、これは誰でも見られる普通の公開ページだ」
と判断されやすくなりました。


**2) public なページにした**
expires_in 10.minutes, public: true
response.headers["Cache-Control"] = "public, max-age=600"

⭐目的：
shareページ（OGPカード用のファイル）が private や Set-Cookie っぽい挙動だと、Xが「個人向けページかも」と判断してカードを出さないことがある。
→ public に寄せて 
🔓 「このページは公開ページです」
👀 「誰が見ても同じ内容です」
という風に明示しました。

※ 10分は「更新頻度が高くない」「でも永遠にキャッシュされても困る」中間の値。

・・・・・・・・・・

つまり今回は、Railsの動的ページを、
「静的ページっぽく振る舞わせた」
ということです。

完全に静的にしたわけではありませんが、X から見たときに

● ログイン不要
● Cookieなし
● 誰でも同じHTML
● 安定して取得できる

という状態に整えました。


**3) OGP画像を先に作っておく**
OgImageGenerator.new(@mofu_diary).generate_to!(path) unless File.exist?(path)

⭐目的：
Xは「HTML→画像」の順で取りに来ることが多いけど、タイミング次第で画像を先に取りに来ることもある。
そのとき 画像がまだ無い/生成中だと失敗しやすい。
→ shareページを開いた時点で画像を用意しておくことで、初回の取りこぼしを減らす。


**4) 画像を “毎回生成しない”**
OgImageGenerator.new(diary).generate_to!(path) unless File.exist?(path)

⭐目的：
リクエストごとに ImageMagick で生成すると遅くなったり失敗したりして、Xが画像取得に失敗しやすい。
→ いったん作ったら ファイルを再利用して安定させる。


**5) 画像は長期キャッシュ（Xのぶれを減らす）**
expires_in 1.year, public: true
response.headers["Cache-Control"] = "public, max-age=31536000, immutable"

⭐目的：
Xは同じ画像を何度も取りに来ることがある。
ここで画像が遅かったり、取りに行くたびに生成が走るとぶれる。
→ 一度成功した画像をずっと使ってもらう（再取得を減らして安定させる）


**6) ブラウザ/クローラーに「画像です」と明示**
response.headers["Content-Disposition"] = 'inline; filename="og.png"'
send_file path, type: "image/png", disposition: "inline"

⭐目的：
「ダウンロード扱い」になったり、content-typeが曖昧だとプレビュー側でコケることがある。
→ inline と image/png を明示して、普通の画像として表示させる。


### ✅今回の学び（覚え方）

**OGPは「画像生成」よりも「Twitterbotが読むHTMLの作法」**が大事なことがある。

✅ publicで安定したHTML

✅ cookie/ログイン前提っぽさを出さない

✅ 画像URLは絶対URLで、画像は200で返す


・・・・・・・・・・・・・・・・・・・・・・・・・・


### ✅チェックリスト(コマンドもあり)
卒業制作サービス「ちょこっと♪もふたいむ」のファイルを例にコードをかいてあります。

**OGPが正常に表示されるための最低条件：**

✅ shareページが 200 OK

✅ HTML内に og:image / twitter:image が存在

✅ og.png が 200 OK / image/png

✅ robots.txt でブロックされていない

✅ Cookie や private cache で「ログインページ扱い」になっていない


**1. shareページが 200 か確認**
curl -s -I "https://YOUR_HOST/mofu_diaries/share/TOKEN"

⭐確認ポイント：
● HTTP/2 200 と出ること
● content-type: text/html と出ること


**2. Twitterbot視点で HTML を確認**
curl -s -A "Twitterbot/1.0" \
"https://YOUR_HOST/mofu_diaries/share/TOKEN" \
| grep -E "og:image|twitter:image|twitter:card" -n

⭐metaタグが出なければ
→ レイアウト / yield :head / format問題の可能性あり


**3. og.png が取得できるか確認（Twitterbot）**
curl -s -D - -o /dev/null -A "Twitterbot/1.0" \
"https://YOUR_HOST/mofu_diaries/share/TOKEN/og.png"

⭐確認ポイント：
● HTTP/2 200 と出ること
● content-type: image/png と出ること
● content-length が0でないこと


**4. 画像取得の安定性チェック（10回テスト）**
for i in $(seq 1 10); do
  curl -s -o /dev/null -A "Twitterbot/1.0" \
    -w "#$i status=%{http_code} time=%{time_total} size=%{size_download}\n" \
    "https://YOUR_HOST/mofu_diaries/share/TOKEN/og.png"
done

⭐見るもの：
● status が全部 200 か？（※１）
● time が極端に跳ねないか？

・・・・・・・・・・

**※１について、timeの目安**
🔍 正常の目安
● 0.1秒〜0.8秒 → かなり良い
● 1秒前後 → 許容範囲

⚠️ ちょっと怪しい
● 2秒以上が混ざる
● 10回中1〜2回だけ 3秒以上になる
→ 初回生成やコールドスタートの可能性

🚨 かなり危険
● 3秒以上が頻繁に出る
● 5秒以上がある
● status が 500 / 503 / 429 が混ざる

X（Twitterbot）は
遅いと諦めることがあるので、
🔥 3秒超えが安定しない状態は危険ゾーン
と覚えておくとよい！


**5. robots.txt 確認**
curl -s "https://YOUR_HOST/robots.txt"

⭐Disallow: / など強い制限がないか確認。（※２）

・・・・・・・・・・

**※２について、OKの基準**
🟢 正常
空・コメントだけ・特に制限なし

⚠️ 注意
User-agent: *
Disallow: /

これは
「すべてのクローラーにサイト全体をクロールするな」
という意味。
→ これがあると カードはほぼ出ない

🚨 危険パターン
Disallow: /mofu_diaries/
や、
Disallow: /share/
など、OGP対象のURLが含まれている場合

→ Xは画像やHTMLを取得しない


**6. Cookie / private キャッシュ確認（重要）**
curl -s -D - -o /dev/null -A "Twitterbot/1.0" \
"https://YOUR_HOST/mofu_diaries/share/TOKEN"

⭐チェック項目：
● Set-Cookie が出ていないか
● Cache-Control: private になっていないか


**7. OGPページ設計の原則（重要）**

OGP用ページは：
● ログイン不要
● Cookieを出さない
● public cache
● 同じURL → 同じHTML
にする。

⭐Controllerでの対策例
before_action :skip_session!, only: [:share, :og]

def skip_session!
  request.session_options[:skip] = true
end
expires_in 10.minutes, public: true


**8. meta最低セット**
これを全部書いておくのもあり

<meta property="og:type" content="website">
<meta property="og:url" content="FULL_URL">
<meta property="og:title" content="TITLE">
<meta property="og:description" content="DESCRIPTION">
<meta property="og:image" content="IMAGE_URL">
<meta property="og:image:width" content="1200">
<meta property="og:image:height" content="630">

<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="TITLE">
<meta name="twitter:description" content="DESCRIPTION">
<meta name="twitter:image" content="IMAGE_URL">

