class CreateConversations < ActiveRecord::Migration[7.1]
  def change
    create_table :conversations do |t|
      t.references :character, null: false, foreign_key: true
      t.integer :kind, null: false
      t.integer :time_slot, null: false
      t.integer :weather_slot, null: false
      t.integer :min_affinity, null: false, default: 0
      t.integer :weight, default: 1
      t.text :text, null: false

      t.timestamps
    end

    add_index :conversations, [:character_id, :kind, :time_slot, :weather_slot]
  end
end
