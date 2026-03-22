class AddExpressionKeyToConversations < ActiveRecord::Migration[7.1]
  def change
    add_column :conversations, :expression_key, :string
  end
end