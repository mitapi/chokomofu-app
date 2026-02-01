class AddKeyToCharacters < ActiveRecord::Migration[7.1]
  def up
    add_column :characters, :key, :string

    execute <<~SQL
      UPDATE characters
      SET key = 'pomemaru'
      WHERE key IS NULL AND name = 'ぽめまる'
    SQL

    execute <<~SQL
      UPDATE characters
      SET key = 'character_' || id
      WHERE key IS NULL OR key = ''
    SQL

    change_column_null :characters, :key, false

    add_index :characters, :key, unique: true
  end

  def down
    remove_index :characters, :key
    remove_column :characters, :key
  end
end