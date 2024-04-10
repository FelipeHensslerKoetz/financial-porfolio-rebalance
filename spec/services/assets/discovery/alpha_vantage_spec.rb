require 'rails_helper'

RSpec.describe Assets::Discovery::AlphaVantage do
  subject(:alpha_vantage_discovery) { described_class.new(keywords:) }

  before do
    create(:data_origin, :alpha_vantage)
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
        VCR.use_cassette('alpha_vantage/asset_discovery_single_equity') do
          assets = alpha_vantage_discovery.call
          asset = assets.first

          expect(assets.count).to eq(1)
          expect(asset.attributes).to include(
            'code' => 'PETR4',
            'name' => 'Petróleo Brasileiro S.A. - Petrobras',
            'business_name' => 'Petróleo Brasileiro S.A. - Petrobras',
            'document' => nil,
            'description' => nil,
            'website' => nil,
            'kind' => 'Equity',
            'sector' => nil,
            'region' => 'Brazil/Sao Paolo',
            'image_path' => nil,
            'market_time' => { 'close' => '17:30', 'open' => '10:00',
                               'timezone' => 'UTC-03' },
            'custom' => false,
            'user_id' => nil,
            'created_at' => be_a(Time),
            'updated_at' => be_a(Time)
          )

          expect(asset.asset_price_trackers.count).to eq(1)
          asset_price_tracker = asset.asset_price_trackers.first

          expect(asset_price_tracker.code).to eq('PETR4.SAO')
          expect(asset_price_tracker.data_origin.name).to eq('Alpha Vantage')
          expect(asset_price_tracker.price).to be_a(BigDecimal)
          expect(asset_price_tracker.currency.code).to eq('BRL')
          expect(asset_price_tracker.last_sync_at).to be_a(Time)
          expect(asset_price_tracker.created_at).to be_a(Time)
          expect(asset_price_tracker.updated_at).to be_a(Time)
          expect(asset_price_tracker.reference_date).to eq(Time.zone.parse('2024-04-05'))
        end
      end
    end

    context 'when searching for a mutual fund' do
      let(:keywords) { 'HGLG11' }

      it 'creates a single asset' do
        VCR.use_cassette('alpha_vantage/asset_discovery_single_mutual_fund') do
          assets = alpha_vantage_discovery.call
          asset = assets.first

          expect(assets.count).to eq(1)
          expect(asset.attributes).to include(
            'code' => 'HGLG11',
            'name' => 'Cshg Logistica - Fundo De Investimento Imobiliario',
            'business_name' => 'Cshg Logistica - Fundo De Investimento Imobiliario',
            'document' => nil,
            'description' => nil,
            'website' => nil,
            'kind' => 'Mutual Fund',
            'sector' => nil,
            'region' => 'Brazil/Sao Paolo',
            'image_path' => nil,
            'market_time' => { 'close' => '17:30', 'open' => '10:00',
                               'timezone' => 'UTC-03' },
            'custom' => false,
            'user_id' => nil,
            'created_at' => be_a(Time),
            'updated_at' => be_a(Time)
          )

          expect(asset.asset_price_trackers.count).to eq(1)
          asset_price_tracker = asset.asset_price_trackers.first

          expect(asset_price_tracker.code).to eq('HGLG11.SAO')
          expect(asset_price_tracker.data_origin.name).to eq('Alpha Vantage')
          expect(asset_price_tracker.price).to be_a(BigDecimal)
          expect(asset_price_tracker.currency.code).to eq('BRL')
          expect(asset_price_tracker.last_sync_at).to be_a(Time)
          expect(asset_price_tracker.created_at).to be_a(Time)
          expect(asset_price_tracker.updated_at).to be_a(Time)
          expect(asset_price_tracker.reference_date).to eq(Time.zone.parse('2024-04-05'))
        end
      end
    end

    context 'when searching for an ETF' do
      let(:keywords) { 'IVVB11' }

      it 'creates a single asset' do
        VCR.use_cassette('alpha_vantage/asset_discovery_single_etf') do
          assets = alpha_vantage_discovery.call
          asset = assets.first

          expect(assets.count).to eq(1)
          expect(asset.attributes).to include(
            'code' => 'IVVB11',
            'name' => 'iShares S&P 500 Fundo de Investimento - Investimento No Exterior',
            'business_name' => 'iShares S&P 500 Fundo de Investimento - Investimento No Exterior',
            'document' => nil,
            'description' => nil,
            'website' => nil,
            'kind' => 'ETF',
            'sector' => nil,
            'region' => 'Brazil/Sao Paolo',
            'image_path' => nil,
            'market_time' => { 'close' => '17:30', 'open' => '10:00',
                               'timezone' => 'UTC-03' },
            'custom' => false,
            'user_id' => nil,
            'created_at' => be_a(Time),
            'updated_at' => be_a(Time)
          )

          expect(asset.asset_price_trackers.count).to eq(1)
          asset_price_tracker = asset.asset_price_trackers.first

          expect(asset_price_tracker.code).to eq('IVVB11.SAO')
          expect(asset_price_tracker.data_origin.name).to eq('Alpha Vantage')
          expect(asset_price_tracker.price).to be_a(BigDecimal)
          expect(asset_price_tracker.currency.code).to eq('BRL')
          expect(asset_price_tracker.last_sync_at).to be_a(Time)
          expect(asset_price_tracker.created_at).to be_a(Time)
          expect(asset_price_tracker.updated_at).to be_a(Time)
          expect(asset_price_tracker.reference_date).to eq(Time.zone.parse('2024-04-05'))
        end
      end
    end
  end

  context 'when there are multiple matches' do
    let(:keywords) { 'petr' }

    it 'creates multiple assets' do
      VCR.use_cassette('alpha_vantage/asset_discovery_multiple_equities') do
        new_assets = alpha_vantage_discovery.call

        expect(new_assets.count).to eq(10)

        new_assets.each do |asset|
          asset_price_tracker = asset.asset_price_trackers.first

          expect(asset.attributes).to include(
            'code' => be_a(String),
            'name' => be_a(String),
            'business_name' => be_a(String),
            'document' => nil,
            'description' => nil,
            'website' => nil,
            'kind' => 'Equity',
            'sector' => nil,
            'region' => be_a(String),
            'image_path' => nil,
            'market_time' => be_a(Hash),
            'custom' => false,
            'user_id' => nil,
            'created_at' => be_a(Time),
            'updated_at' => be_a(Time)
          )

          expect(asset_price_tracker.data_origin.name).to eq('Alpha Vantage')
          expect(asset_price_tracker.price).to be_a(BigDecimal)
          expect(asset_price_tracker.currency).to be_a(Currency)
          expect(asset_price_tracker.last_sync_at).to be_a(Time)
          expect(asset_price_tracker.created_at).to be_a(Time)
          expect(asset_price_tracker.updated_at).to be_a(Time)
        end
      end
    end
  end

  context 'when there are no matches' do
    let(:keywords) { '?????????????' }

    it 'returns an empty array' do
      VCR.use_cassette('alpha_vantage/asset_discovery_no_matches') do
        assets = alpha_vantage_discovery.call

        expect(assets).to be_empty
        expect(Asset.count).to eq(0)
      end
    end
  end

  context 'when the asset is already discovered' do
    context 'when the asset was discovered by Alpha Vantage' do
      let(:keywords) { 'PETR4' }

      before do
        asset = create(:asset, code: 'PETR4')
        create(:asset_price_tracker,
               asset:,
               code: 'PETR4.SAO',
               data_origin: DataOrigin.find_by(name: 'Alpha Vantage'),
               price: 100.0,
               currency: Currency.find_by(code: 'BRL'),
               last_sync_at: 1.day.ago)
      end

      it 'return an empty array' do
        VCR.use_cassette('alpha_vantage/asset_discovery_single_equity_already_existent') do
          assets = alpha_vantage_discovery.call

          expect(assets.count).to eq(0)
          expect(Asset.count).to eq(1)
          expect(AssetPriceTracker.count).to eq(1)
        end
      end
    end

    context 'when the asset was discovered by another data origin' do
      context 'when Alpha Vantage knows the asset' do
        let(:keywords) { 'PETR4' }

        before do
          create(:asset, code: 'PETR4')
        end

        it 'creates a asset price tracker' do
          VCR.use_cassette('alpha_vantage/asset_discovery_single_equity_already_existent_by_other_source') do
            assets = alpha_vantage_discovery.call
            asset = assets.first.reload

            expect(assets.count).to eq(1)
            expect(asset.code).to eq('PETR4')

            expect(asset.asset_price_trackers.count).to eq(1)
            asset_price_tracker = asset.asset_price_trackers.first

            expect(asset_price_tracker.code).to eq('PETR4.SAO')
            expect(asset_price_tracker.data_origin.name).to eq('Alpha Vantage')
            expect(asset_price_tracker.price).to be_a(BigDecimal)
            expect(asset_price_tracker.currency.code).to eq('BRL')
            expect(asset_price_tracker.last_sync_at).to be_a(Time)
            expect(asset_price_tracker.created_at).to be_a(Time)
            expect(asset_price_tracker.updated_at).to be_a(Time)
            expect(asset_price_tracker.reference_date).to eq(Time.zone.parse('2024-04-05'))
          end
        end
      end

      context 'when Alpha Vantage does not know the asset' do
        let(:keywords) { '?????????????' }

        before do
          create(:asset, code: '?????????????')
        end

        it 'returns an empty array' do
          VCR.use_cassette('alpha_vantage/asset_discovery_no_matches') do
            assets = alpha_vantage_discovery.call

            expect(assets).to be_empty
            expect(Asset.count).to eq(1)
            expect(AssetPriceTracker.count).to eq(0)
          end
        end
      end
    end
  end
end
