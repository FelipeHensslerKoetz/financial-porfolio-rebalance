require 'rails_helper'

RSpec.describe Assets::Discovery::Global do
  subject(:global_discovery) { described_class.new(keywords:) }

  before do
    create(:partner_resource, :hg_brasil_stock_price)
    create(:partner_resource, :alpha_vantage_global_quote)
    create(:currency, code: 'BRL', name: 'Brazilian Real')
    create(:currency, code: 'USD', name: 'United States Dollar')
  end

  context 'when assetS were found in one partner resource' do
    let(:keywords) { 'NVDA' }

    it 'creates a the asset with one asset price' do
      VCR.use_cassette('global_discovery/single_partner_resource_discovery') do
        assets = global_discovery.call

        expect(assets.count).to eq(2)
        expect(assets.first.asset_prices.count).to eq(1)
        expect(assets.second.asset_prices.count).to eq(1)
        expect(assets.first.asset_prices.first.partner_resource.name).to eq('Alpha Vantage - Global Quote')
        expect(assets.last.asset_prices.first.partner_resource.name).to eq('Alpha Vantage - Global Quote')
      end
    end
  end

  context 'when asset was found in multiple partner resources' do
    let(:keywords) { 'PETR4' }

    it 'creates a the asset with two asset prices' do
      VCR.use_cassette('global_discovery/multiple_partner_resource_discovery') do
        assets = global_discovery.call

        expect(assets.count).to eq(1)
        expect(assets.first.asset_prices.count).to eq(2)
        expect(assets.first.asset_prices.first.partner_resource.name).to eq('HG Brasil - Stock Price')
        expect(assets.first.asset_prices.second.partner_resource.name).to eq('Alpha Vantage - Global Quote')
      end
    end
  end

  context 'when no assets were not found' do
    let(:keywords) { 'NOT_FOUND' }

    it 'does not create any asset' do
      VCR.use_cassette('global_discovery/not_found') do
        assets = global_discovery.call

        expect(assets).to be_empty
        expect(Asset.count).to eq(0)
        expect(AssetPrice.count).to eq(0)
      end
    end
  end
end
