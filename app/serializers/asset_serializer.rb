class AssetSerializer < ActiveModel::Serializer
  attributes :id, :code, :name, :business_name, :kind, :image_path,
             :custom, :user_id, :created_at, :updated_at
end
