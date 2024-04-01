class CreateAssets < ActiveRecord::Migration[7.1]
  def change
    create_table :assets do |t|
      t.string :code, null: false
      t.string :name, null: false
      t.string :business_name, null: false
      t.string :document
      t.string :description
      t.string :website
      t.string :kind
      t.string :sector
      t.string :region
      t.json :image_path
      t.json :market_time
      t.boolean :custom, null: false, default: false
      t.references :user, null: true, foreign_key: true
      t.timestamps
    end

    add_index :assets, :code, unique: true
  end
end
