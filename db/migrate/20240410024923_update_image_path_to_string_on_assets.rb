class UpdateImagePathToStringOnAssets < ActiveRecord::Migration[7.1]
  def change
    change_column :assets, :image_path, :string
  end
end
