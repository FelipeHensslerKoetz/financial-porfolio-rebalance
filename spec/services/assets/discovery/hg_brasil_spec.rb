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
          expect(new_asset.code).to eq('PETR4')
          expect(new_asset.name).to eq('Petroleo Brasileiro S.A. Petrobras')
          expect(new_asset.business_name).to eq('Petrobras')
          expect(new_asset.kind).to eq('stock')
          expect(new_asset.custom).to eq(false)

          asset_price_tracker = new_asset.asset_price_trackers.first

          expect(new_asset.asset_price_trackers.count).to eq(1)
          expect(asset_price_tracker).to be_a(AssetPriceTracker)
          expect(asset_price_tracker.currency.code).to eq('BRL')
          expect(asset_price_tracker.data_origin.name).to eq('HG Brasil')
          expect(asset_price_tracker.price).to be_a(BigDecimal)
          expect(asset_price_tracker.last_sync_at).to be_a(Time)
          expect(asset_price_tracker.created_at).to be_a(Time)
          expect(asset_price_tracker.updated_at).to be_a(Time)
          expect(asset_price_tracker.reference_date).to be_a(Time)
        end
      end
    end

    context 'when symbol is a fii' do
      let(:symbol) { 'HGLG11' }

      it 'creates a new Asset and AssetPriceTrack' do
        VCR.use_cassette('hg_brasil/asset_discovery_fii_success') do
          new_asset = hg_brasil_asset_discovery

          expect(new_asset).to be_a(Asset)
          expect(new_asset.code).to eq('HGLG11')
          expect(new_asset.name).to eq('CSHG Logstica Fundo Investimento Imobiliario FII')
          expect(new_asset.business_name).to eq('FII CSHG Log')
          expect(new_asset.kind).to eq('fii')
          expect(new_asset.custom).to eq(false)

          asset_price_tracker = new_asset.asset_price_trackers.first

          expect(new_asset.asset_price_trackers.count).to eq(1)
          expect(asset_price_tracker).to be_a(AssetPriceTracker)
          expect(asset_price_tracker.currency.code).to eq('BRL')
          expect(asset_price_tracker.data_origin.name).to eq('HG Brasil')
          expect(asset_price_tracker.price).to be_a(BigDecimal)
          expect(asset_price_tracker.last_sync_at).to be_a(Time)
          expect(asset_price_tracker.created_at).to be_a(Time)
          expect(asset_price_tracker.updated_at).to be_a(Time)
          expect(asset_price_tracker.reference_date).to be_a(Time)
        end
      end
    end

    context 'when symbol is an ETF' do
      let(:symbol) { 'BOVA11' }

      it 'creates a new Asset and AssetPriceTrack' do
        VCR.use_cassette('hg_brasil/asset_discovery_etf_success') do
          new_asset = hg_brasil_asset_discovery

          expect(new_asset).to be_a(Asset)
          expect(new_asset.code).to eq('BOVA11')
          expect(new_asset.name).to eq('iShares Ibovespa Fundo de Índice ETF')
          expect(new_asset.business_name).to eq('iShares Ibovespa Fundo de Índice ETF')
          expect(new_asset.kind).to eq('stock')
          expect(new_asset.custom).to eq(false)

          asset_price_tracker = new_asset.asset_price_trackers.first

          expect(new_asset.asset_price_trackers.count).to eq(1)
          expect(asset_price_tracker).to be_a(AssetPriceTracker)
          expect(asset_price_tracker.currency.code).to eq('BRL')
          expect(asset_price_tracker.data_origin.name).to eq('HG Brasil')
          expect(asset_price_tracker.price).to be_a(BigDecimal)
          expect(asset_price_tracker.last_sync_at).to be_a(Time)
          expect(asset_price_tracker.created_at).to be_a(Time)
          expect(asset_price_tracker.updated_at).to be_a(Time)
          expect(asset_price_tracker.reference_date).to be_a(Time)
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
