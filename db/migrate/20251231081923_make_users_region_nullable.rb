class MakeUsersRegionNullable < ActiveRecord::Migration[7.1]
  def up
    change_column_default :users, :region, from: 0, to: nil
    change_column_null :users, :region, true
  end

  def down
    change_column_null :users, :region, false
    change_column_default :users, :region, from: nil, to: 0
  end
end