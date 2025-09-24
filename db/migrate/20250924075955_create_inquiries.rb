class CreateInquiries < ActiveRecord::Migration[7.1]
  def change
    create_table :inquiries do |t|
      t.string :sender_name, null: false
      t.string :email, null: false
      t.text :body, null: false

      t.timestamps
    end
  end
end
