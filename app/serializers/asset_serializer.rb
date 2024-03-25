class AssetSerializer < ActiveModel::Serializer
  attributes :id, :name, :identifier, :created_at, :updated_at
end
