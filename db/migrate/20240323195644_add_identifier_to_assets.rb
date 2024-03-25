class AddIdentifierToAssets < ActiveRecord::Migration[7.1]
  def change
    add_column :assets, :identifier, :string, null: false
    add_index :assets, :identifier, unique: true
  end
end
