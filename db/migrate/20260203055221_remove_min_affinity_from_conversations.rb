class RemoveMinAffinityFromConversations < ActiveRecord::Migration[7.1]
  def change
    remove_column :conversations, :min_affinity, :integer
  end
end
