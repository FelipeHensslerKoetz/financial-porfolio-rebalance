require 'rails_helper'

RSpec.describe Assets::Discovery::AlphaVantage do
  subject(:alpha_vantage_discovery) { described_class.new(keywords:) }

  before do
    create(:partner_resource, :alpha_vantage_global_quote)
    create(:currency, code: 'USD', name: 'United States Dollar')
    create(:currency, code: 'BRL', name: 'Brazilian Real')
    create(:currency, code: 'GBX', name: 'Pound Sterling')
    create(:currency, code: 'INR', name: 'Indian Rupee')
    create(:currency, code: 'EUR', name: 'Euro')
    create(:currency, code: 'CAD', name: 'Canadian Dollar')
  end

  context 'when there is one match' do
    context 'when searching for an equity' do
      let(:keywords) { 'PETR4' }

      it 'creates a single asset' do
        VCR.use_cassette('alpha_vantage_global_quote/asset_discovery_single_equity') do
          assets = alpha_vantage_discovery.call
          asset = assets.first
          asset_price = asset.asset_prices.first

          expect(Asset.count).to eq(1)
          expect(asset.code).to eq('PETR4')
          expect(asset.name).to eq('Petróleo Brasileiro S.A. - Petrobras')
          expect(asset.business_name).to eq('Petróleo Brasileiro S.A. - Petrobras')
          expect(asset.kind).to eq('Equity')
          expect(asset.custom).to eq(false)
          expect(asset.asset_prices.count).to eq(1)
          expect(asset_price.code).to eq('PETR4.SAO')
          expect(asset_price.partner_resource.name).to eq('Alpha Vantage - Global Quote')
          expect(asset_price.price).to be_a(BigDecimal)
          expect(asset_price.currency.code).to eq('BRL')
          expect(asset_price.last_sync_at).to be_a(Time)
          expect(asset_price.created_at).to be_a(Time)
          expect(asset_price.updated_at).to be_a(Time)
          expect(asset_price.reference_date).to be_a(Time)
        end
      end
    end

    context 'when searching for a mutual fund' do
      let(:keywords) { 'HGLG11' }

      it 'creates a single asset' do
        VCR.use_cassette('alpha_vantage_global_quote/asset_discovery_single_mutual_fund') do
          assets = alpha_vantage_discovery.call
          asset = assets.first
          asset_price = asset.asset_prices.first

          expect(Asset.count).to eq(1)
          expect(asset.code).to eq('HGLG11')
          expect(asset.name).to eq('Cshg Logistica - Fundo De Investimento Imobiliario')
          expect(asset.business_name).to eq('Cshg Logistica - Fundo De Investimento Imobiliario')
          expect(asset.kind).to eq('Mutual Fund')
          expect(asset.custom).to eq(false)
          expect(asset.asset_prices.count).to eq(1)
          expect(asset_price.code).to eq('HGLG11.SAO')
          expect(asset_price.partner_resource.name).to eq('Alpha Vantage - Global Quote')
          expect(asset_price.price).to be_a(BigDecimal)
          expect(asset_price.currency.code).to eq('BRL')
          expect(asset_price.last_sync_at).to be_a(Time)
          expect(asset_price.created_at).to be_a(Time)
          expect(asset_price.updated_at).to be_a(Time)
          expect(asset_price.reference_date).to be_a(Time)
        end
      end
    end

    context 'when searching for an ETF' do
      let(:keywords) { 'IVVB11' }

      it 'creates a single asset' do
        VCR.use_cassette('alpha_vantage_global_quote/asset_discovery_single_etf') do
          assets = alpha_vantage_discovery.call
          asset = assets.first
          asset_price = asset.asset_prices.first

          expect(Asset.count).to eq(1)
          expect(asset.code).to eq('IVVB11')
          expect(asset.name).to eq('iShares S&P 500 Fundo de Investimento - Investimento No Exterior')
          expect(asset.business_name).to eq('iShares S&P 500 Fundo de Investimento - Investimento No Exterior')
          expect(asset.kind).to eq('ETF')
          expect(asset.custom).to eq(false)
          expect(asset.asset_prices.count).to eq(1)
          expect(asset_price.code).to eq('IVVB11.SAO')
          expect(asset_price.partner_resource.name).to eq('Alpha Vantage - Global Quote')
          expect(asset_price.price).to be_a(BigDecimal)
          expect(asset_price.currency.code).to eq('BRL')
          expect(asset_price.last_sync_at).to be_a(Time)
          expect(asset_price.created_at).to be_a(Time)
          expect(asset_price.updated_at).to be_a(Time)
          expect(asset_price.reference_date).to be_a(Time)
        end
      end
    end
  end

  context 'when there are multiple matches' do
    let(:keywords) { 'petr' }

    it 'creates multiple assets' do
      VCR.use_cassette('alpha_vantage_global_quote/asset_discovery_multiple_equities') do
        new_assets = alpha_vantage_discovery.call

        expect(new_assets.count).to eq(10)

        new_assets.each do |asset|
          asset_price = asset.asset_prices.first

          expect(asset.code).to be_a(String)
          expect(asset.name).to be_a(String)
          expect(asset.business_name).to be_a(String)
          expect(asset.kind).to be_a(String)
          expect(asset.custom).to eq(false)
          expect(asset_price.partner_resource.name).to eq('Alpha Vantage - Global Quote')
          expect(asset_price.price).to be_a(BigDecimal)
          expect(asset_price.currency).to be_a(Currency)
          expect(asset_price.last_sync_at).to be_a(Time)
          expect(asset_price.created_at).to be_a(Time)
          expect(asset_price.updated_at).to be_a(Time)
        end
      end
    end
  end

  context 'when there are no matches' do
    let(:keywords) { '?????????????' }

    it 'returns an empty array' do
      VCR.use_cassette('alpha_vantage_global_quote/asset_discovery_no_matches') do
        assets = alpha_vantage_discovery.call

        expect(assets).to be_empty
        expect(Asset.count).to eq(0)
      end
    end
  end

  context 'when the asset is already discovered' do
    context 'when the asset was discovered by Alpha Vantage - Global Quote' do
      let(:keywords) { 'PETR4' }

      before do
        asset = create(:asset, code: 'PETR4')
        create(:asset_price,
               asset:,
               code: 'PETR4.SAO',
               partner_resource: PartnerResource.find_by(name: 'Alpha Vantage - Global Quote'),
               price: 100.0,
               currency: Currency.find_by(code: 'BRL'),
               last_sync_at: 1.day.ago)
      end

      it 'return an empty array' do
        VCR.use_cassette('alpha_vantage_global_quote/asset_discovery_single_equity_already_existent') do
          assets = alpha_vantage_discovery.call

          expect(assets.count).to eq(0)
          expect(Asset.count).to eq(1)
          expect(AssetPrice.count).to eq(1)
        end
      end
    end

    context 'when the asset was discovered by another data origin' do
      context 'when Alpha Vantage - Global Quote knows the asset' do
        let(:keywords) { 'PETR4' }

        before do
          create(:asset, code: 'PETR4')
        end

        it 'creates an asset price' do
          VCR.use_cassette('alpha_vantage_global_quote/asset_discovery_single_equity_already_existent_by_other_source') do
            assets = alpha_vantage_discovery.call
            asset = assets.first.reload
            asset_price = asset.asset_prices.first

            expect(Asset.count).to eq(1)
            expect(asset.code).to eq('PETR4')
            expect(asset.asset_prices.count).to eq(1)
            expect(asset_price.code).to eq('PETR4.SAO')
            expect(asset_price.partner_resource.name).to eq('Alpha Vantage - Global Quote')
            expect(asset_price.price).to be_a(BigDecimal)
            expect(asset_price.currency.code).to eq('BRL')
            expect(asset_price.last_sync_at).to be_a(Time)
            expect(asset_price.created_at).to be_a(Time)
            expect(asset_price.updated_at).to be_a(Time)
            expect(asset_price.reference_date).to be_a(Time)
          end
        end
      end

      context 'when Alpha Vantage - Global Quote does not know the asset' do
        let(:keywords) { '?????????????' }

        before do
          create(:asset, code: '?????????????')
        end

        it 'returns an empty array' do
          VCR.use_cassette('alpha_vantage_global_quote/asset_discovery_no_matches') do
            assets = alpha_vantage_discovery.call

            expect(assets).to be_empty
            expect(Asset.count).to eq(1)
            expect(AssetPrice.count).to eq(0)
          end
        end
      end
    end
  end
end
