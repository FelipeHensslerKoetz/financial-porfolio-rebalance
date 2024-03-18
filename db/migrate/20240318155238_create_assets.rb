class CreateAssets < ActiveRecord::Migration[7.1]
  def change
    create_table :assets do |t|
      t.string :name, null: false
      t.references :asset_type, null: false, foreign_key: true
      t.string :sector
      t.string :origin_country
      t.string :image_path
      t.boolean :custom, null: false, default: false
      t.references :user, null: true, foreign_key: true

      t.timestamps
    end
  end
end
