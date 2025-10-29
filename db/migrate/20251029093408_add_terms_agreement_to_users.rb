class AddTermsAgreementToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :terms_agreed_at, :datetime
    add_column :users, :terms_version, :string
  end
end
