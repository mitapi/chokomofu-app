class CreateMofuDiaries < ActiveRecord::Migration[7.1]
  def change
    create_table :mofu_diaries do |t|
      t.references :user, null: false, foreign_key: true
      t.date :date
      t.string :title
      t.string :line1
      t.string :line2
      t.integer :weather_slot
      t.integer :time_slot
      t.string :character_key

      t.timestamps
    end
    add_index :mofu_diaries, [:user_id, :date], unique: true
  end
end
