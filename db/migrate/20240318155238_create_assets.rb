class CreateAssets < ActiveRecord::Migration[7.1]
  def change
    create_table :assets do |t|
      t.string :identifier, null: false
      t.string :name, null: false
      t.string :asset_type
      t.string :sector
      t.string :origin_country
      t.string :image_path
      t.boolean :custom, null: false, default: false
      t.references :user, null: true, foreign_key: true
      t.timestamps
    end

    add_index :assets, :identifier, unique: true
  end
end
