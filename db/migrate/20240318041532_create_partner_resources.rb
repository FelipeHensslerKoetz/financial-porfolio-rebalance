class CreatePartnerResources < ActiveRecord::Migration[7.1]
  def change
    create_table :partner_resources do |t|
      t.string :name, null: false
      t.string :description
      t.string :url
      t.references :partner, null: true, foreign_key: true
    end

    add_index :partner_resources, :name, unique: true
  end
end