class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :guest_uid, null: false
      t.integer :auth_kind, null: false, default: 0
      t.string :nickname
      t.string :email
      t.string :crypted_password
      t.string :salt

      t.timestamps
    end

    add_index :users, :guest_uid, unique: true
    add_index :users, :email, unique: true
  end
end
