class AddUniqueIndexToConversationsCode < ActiveRecord::Migration[7.1]
  def change
    add_index :conversations, :code, unique: true
  end
end