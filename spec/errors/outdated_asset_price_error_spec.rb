require 'rails_helper'

RSpec.describe OutdatedAssetPriceError, type: :error do
  describe '#initialize' do
    it 'returns the error message' do
      asset = create(:asset)

      error = OutdatedAssetPriceError.new(asset:)

      expect(error.message).to eq("Asset with id: #{asset.id} has only outdated prices")
    end
  end

  describe '#asset' do
    it 'returns the asset' do
      asset = create(:asset)

      error = OutdatedAssetPriceError.new(asset:)

      expect(error.asset).to eq(asset)
    end
  end
end
