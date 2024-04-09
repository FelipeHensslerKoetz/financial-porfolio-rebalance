class AssetSerializer < ActiveModel::Serializer
  attributes :id, :code, :name, :business_name, :document, :description,
             :website, :kind, :sector, :region, :image_path, :market_time,
             :custom, :user_id, :created_at, :updated_at
end
