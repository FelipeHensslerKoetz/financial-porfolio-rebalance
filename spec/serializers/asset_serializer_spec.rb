require 'rails_helper'

RSpec.describe AssetSerializer do
  let(:asset) { create(:asset) }
  let(:serializer) { described_class.new(asset) }

  it 'returns the expected attributes' do
    expect(serializer.attributes.keys).to contain_exactly(
      :id, :code, :name, :business_name, :kind, :image_path,
      :custom, :user_id, :created_at, :updated_at
    )
  end
end
