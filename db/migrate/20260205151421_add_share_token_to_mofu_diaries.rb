class AddShareTokenToMofuDiaries < ActiveRecord::Migration[7.1]
  def up
    add_column :mofu_diaries, :share_token, :string

    # 既存データにトークン付与
    say_with_time "Backfilling mofu_diaries.share_token" do
      MofuDiary.reset_column_information
      MofuDiary.find_each do |d|
        d.update_columns(share_token: SecureRandom.urlsafe_base64(12))
      end
    end

    change_column_null :mofu_diaries, :share_token, false
    add_index :mofu_diaries, :share_token, unique: true
  end

  def down
    remove_index :mofu_diaries, :share_token
    remove_column :mofu_diaries, :share_token
  end
end