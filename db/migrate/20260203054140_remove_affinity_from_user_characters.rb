class RemoveAffinityFromUserCharacters < ActiveRecord::Migration[7.1]
  def change
    remove_column :user_characters, :affinity, :integer
  end
end
