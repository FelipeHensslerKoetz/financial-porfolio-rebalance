class CreateDataOrigins < ActiveRecord::Migration[7.1]
  def change
    create_table :data_origins do |t|
      t.string :name, null: false, unique: true
      t.string :url, null: false

      t.timestamps
    end
  end
end
