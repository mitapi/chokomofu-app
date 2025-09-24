class CreateConversationChoices < ActiveRecord::Migration[7.1]
  def change
    create_table :conversation_choices do |t|
      t.references :conversation, null: false, foreign_key: true
      t.string :label, null: false
      t.integer :position, null: false
      t.references :next_conversation,  null: true,  foreign_key: { to_table: :conversations }
      # 会話の終端（次がない）を表せるように null: true をつけました

      t.timestamps
    end
  end
end
