class AddSnackTypeToInteractions < ActiveRecord::Migration[7.1]
  def change
    add_column :interactions, :snack_type, :integer
  end
end
