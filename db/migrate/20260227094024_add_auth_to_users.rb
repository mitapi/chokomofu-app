class AddAuthToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :password_digest, :string unless column_exists?(:users, :password_digest)

    # すでに index があっても落ちないようにする
    add_index :users, :email, unique: true unless index_exists?(:users, :email, unique: true)
  end
end
