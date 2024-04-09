require 'rails_helper'

RSpec.describe Assets::Discovery::HgBrasil do
  subject(:hg_brasil_asset_discovery) { described_class.call(symbol:) }

  before do
    create(:data_origin, :hg_brasil)
    create(:currency, :brl)
  end

  context 'when symbols exists' do
    context 'when symbol is a stock' do
      let(:symbol) { 'PETR4' }

      it 'creates a new Asset and AssetPriceTrack' do
        VCR.use_cassette('hg_brasil/asset_discovery_success') do
          new_asset = hg_brasil_asset_discovery

          expect(new_asset).to be_a(Asset)

          expect(new_asset.attributes).to include(
            'code' => 'PETR4',
            'name' => 'Petroleo Brasileiro S.A. Petrobras',
            'business_name' => 'Petrobras',
            'document' => '33.000.167/0001-01',
            'description' => 'Pesquisa. Lavra. Refinação. Processamento. Comércio E Transporte de Petróleo. de Seus Derivados. de Gás Natural E de Outros Hidrocarbonetos Fluidos. Além Das Atividades Vinculadas à Energia.',
            'website' => 'http://www.petrobras.com.br/',
            'kind' => 'stock',
            'sector' => 'Petróleo. Gás e Biocombustíveis / Petróleo. Gás e Biocombustíveis / Exploração. Refino e Distribuição',
            'region' => 'Brazil/Sao Paulo',
            'image_path' => {
              'big' => 'https://assets.hgbrasil.com/finance/companies/big/petrobras.png', 'small' => 'https://assets.hgbrasil.com/finance/companies/small/petrobras.png'
            },
            'market_time' => { 'open' => '10:00', 'close' => '17:30',
                               'timezone' => -3 },
            'custom' => false,
            'user_id' => nil,
            'created_at' => be_a(Time),
            'updated_at' => be_a(Time)
          )

          asset_price_tracker = new_asset.asset_price_trackers.first

          expect(new_asset.asset_price_trackers.count).to eq(1)
          expect(asset_price_tracker).to be_a(AssetPriceTracker)
          expect(asset_price_tracker.currency.code).to eq('BRL')
          expect(asset_price_tracker.data_origin.name).to eq('HG Brasil')
          expect(asset_price_tracker.price).to be_a(BigDecimal)
          expect(asset_price_tracker.last_sync_at).to be_a(Time)
          expect(asset_price_tracker.created_at).to be_a(Time)
          expect(asset_price_tracker.updated_at).to be_a(Time)
        end
      end
    end

    context 'when symbol is a fii' do
      let(:symbol) { 'HGLG11' }

      it 'creates a new Asset and AssetPriceTrack' do
        VCR.use_cassette('hg_brasil/asset_discovery_fii_success') do
          new_asset = hg_brasil_asset_discovery

          expect(new_asset).to be_a(Asset)

          expect(new_asset.attributes).to include(
            'code' => 'HGLG11',
            'name' => 'CSHG Logstica Fundo Investimento Imobiliario FII',
            'business_name' => 'FII CSHG Log',
            'document' => '11.728.688/0001-47',
            'description' => 'Financeiro e Outros/Fundos/Fundos Imobiliários',
            'website' => 'https://www.cshg.com.br/',
            'kind' => 'fii',
            'sector' => 'Imóveis Industriais e Logísticos',
            'region' => 'Brazil/Sao Paulo',
            'image_path' => nil,
            'market_time' => { 'close' => '17:30', 'open' => '10:00',
                               'timezone' => -3 },
            'custom' => false,
            'user_id' => nil,
            'created_at' => be_a(Time),
            'updated_at' => be_a(Time)
          )

          asset_price_tracker = new_asset.asset_price_trackers.first

          expect(new_asset.asset_price_trackers.count).to eq(1)
          expect(asset_price_tracker).to be_a(AssetPriceTracker)
          expect(asset_price_tracker.currency.code).to eq('BRL')
          expect(asset_price_tracker.data_origin.name).to eq('HG Brasil')
          expect(asset_price_tracker.price).to be_a(BigDecimal)
          expect(asset_price_tracker.last_sync_at).to be_a(Time)
          expect(asset_price_tracker.created_at).to be_a(Time)
          expect(asset_price_tracker.updated_at).to be_a(Time)
        end
      end
    end

    context 'when symbol is an ETF' do
      let(:symbol) { 'BOVA11' }

      it 'creates a new Asset and AssetPriceTrack' do
        VCR.use_cassette('hg_brasil/asset_discovery_etf_success') do
          new_asset = hg_brasil_asset_discovery

          expect(new_asset).to be_a(Asset)

          expect(new_asset.attributes).to include(
            'code' => 'BOVA11',
            'name' => 'iShares Ibovespa Fundo de Índice ETF',
            'business_name' => 'iShares Ibovespa Fundo de Índice ETF',
            'document' => nil,
            'description' => nil,
            'website' => nil,
            'kind' => 'stock',
            'sector' => nil,
            'region' => 'Brazil/Sao Paolo',
            'image_path' => nil,
            'market_time' => { 'close' => '17:30', 'open' => '10:00',
                               'timezone' => -3 },
            'custom' => false,
            'user_id' => nil,
            'created_at' => be_a(Time),
            'updated_at' => be_a(Time)
          )

          asset_price_tracker = new_asset.asset_price_trackers.first

          expect(new_asset.asset_price_trackers.count).to eq(1)
          expect(asset_price_tracker).to be_a(AssetPriceTracker)
          expect(asset_price_tracker.currency.code).to eq('BRL')
          expect(asset_price_tracker.data_origin.name).to eq('HG Brasil')
          expect(asset_price_tracker.price).to be_a(BigDecimal)
          expect(asset_price_tracker.last_sync_at).to be_a(Time)
          expect(asset_price_tracker.created_at).to be_a(Time)
          expect(asset_price_tracker.updated_at).to be_a(Time)
        end
      end
    end
  end

  context 'when symbols does not exists' do
    let(:symbol) { 'INVALID' }

    it 'returns empty array' do
      VCR.use_cassette('hg_brasil/asset_discovery_not_found') do
        expect(hg_brasil_asset_discovery).to be_nil
      end
    end
  end

  context 'when request fails' do
    let(:symbol) { 'PETR4' }

    before do
      allow_any_instance_of(Faraday::Connection).to receive(:get).and_raise(Faraday::TimeoutError)
    end

    it 'returns empty array' do
      VCR.use_cassette('hg_brasil/asset_discovery_error') do
        expect(hg_brasil_asset_discovery).to be_nil
      end
    end
  end
end
