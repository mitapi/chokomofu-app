class AddRegionToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :region, :integer, null: false, default: 0
  end
end
