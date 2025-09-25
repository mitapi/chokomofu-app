class AddCodeToConversations < ActiveRecord::Migration[7.1]
  def change
    add_column :conversations, :code, :string
  end
end
