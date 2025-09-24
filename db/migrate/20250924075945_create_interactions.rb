class CreateInteractions < ActiveRecord::Migration[7.1]
  def change
    create_table :interactions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :character, null: false, foreign_key: true
      t.integer :kind, null: false, default: 0
      t.datetime :happened_at, null: false

      t.timestamps
    end

    add_index :interactions, [:user_id, :kind, :happened_at]
  end
end
