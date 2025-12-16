class AddRoleToConversations < ActiveRecord::Migration[7.1]
  def change
    add_column :conversations, :role, :integer, null: false, default: 0
  end
end
