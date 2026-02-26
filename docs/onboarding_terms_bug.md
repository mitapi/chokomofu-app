# Onboarding：利用規約チェックが再描画で外れてしまう問題

## 🐛 発生していた問題

オンボーディング画面で以下の挙動が発生していた：

● ニックネーム・地域・規約同意の3項目がある
● 他項目でバリデーションエラーが出て `render :edit` された場合、
  規約チェックが「未同意」に戻ってしまうことがあった

特に、

1. 規約チェックON + 他項目エラー
2. 再描画では規約OKに見える
3. 再度他項目エラーを出す
4. 規約チェックが未同意に戻る

という不安定な挙動が発生していた。

---

## 🎯 原因

`terms_agreed_at` を **保存成功前に controller でセットしていたこと**が原因。

```ruby
if user_params[:terms].to_s == "1" && @user.terms_agreed_at.blank?
  @user.terms_agreed_at = Time.current
  @user.terms_version = "2025-10-30"
end

@user.save が失敗すると DB には保存されない
↓
しかしそのリクエスト内では terms_agreed_at がセットされている
↓
次のリクエストでは DB から読み直すため terms_agreed_at は空に戻る

その結果、チェック状態が揺れていた。

---

## 💡 解決方法

① controller から同意日時のセット処理を削除
def update
  @user = current_user
  @user.assign_attributes(user_params)

  if @user.save
    redirect_to welcome_guide_path
  else
    render :edit, status: :unprocessable_entity
  end
end


② Userモデルに保存時処理を移動
attr_accessor :terms

before_save :stamp_terms_agreement,
  if: -> { terms.to_s == "1" && terms_agreed_at.blank? }

def stamp_terms_agreement
  self.terms_agreed_at = Time.current
  self.terms_version   = "2025-10-30"
end

これにより：

✅ 保存成功時のみ terms_agreed_at がセットされる
✅ バリデーション失敗時は params の値だけが保持される
↓
チェック状態が安定する


③ チェックボックスを安定形式に
<%= f.check_box :terms, {}, "1", "0" %>

これにより "1" / "0" が常に送信される。

---

## 💡 学び

✅保存成功前に DB カラムを書き換えると状態が揺れることがある

✅一時的なフォーム値は params / 仮想属性で扱う

✅永続化は before_save などモデル側に寄せる方が安定する

✅controller は「流れ」、model は「データの責務」

---

## 🏁 結果

✅規約チェックの状態が安定

✅再描画時の挙動が自然になった

✅責務の分離も改善できた