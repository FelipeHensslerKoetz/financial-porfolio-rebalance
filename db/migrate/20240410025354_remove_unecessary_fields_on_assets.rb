class RemoveUnecessaryFieldsOnAssets < ActiveRecord::Migration[7.1]
  def change
    remove_column :assets, :document, :string
    remove_column :assets, :description, :string
    remove_column :assets, :website, :string
    remove_column :assets, :sector, :string
  end
end
