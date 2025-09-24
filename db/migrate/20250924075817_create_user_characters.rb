class CreateUserCharacters < ActiveRecord::Migration[7.1]
  def change
    create_table :user_characters do |t|
      t.references :user, null: false, foreign_key: true
      t.references :character, null: false, foreign_key: true
      t.integer :affinity, null: false, default: 0
      t.boolean :is_selected, null: false, default: false
      t.datetime :last_interacted_at

      t.timestamps
    end

    add_index :user_characters, [:user_id, :character_id], unique: true
    # 1ユーザー×1キャラを重複禁止にするためにuniqueを付けました
  end
end
