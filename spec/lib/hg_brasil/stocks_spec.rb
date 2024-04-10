require 'rails_helper'

RSpec.describe HgBrasil::Stocks do
  describe '#asset_details' do
    subject(:asset_details) { described_class.new.asset_details(symbol:) }

    context 'when searching for a stock price' do
      context 'wih valid symbol' do
        let(:symbol) { 'PETR4' }

        it 'returns the stock price' do
          VCR.use_cassette('asset_details/valid_symbol') do
            result = asset_details

            expect(result).to be_a(Hash)
            expect(result).to include(
              code: 'PETR4',
              kind: 'stock',
              business_name: 'Petrobras',
              name: 'Petroleo Brasileiro S.A. Petrobras',
              price: 38.73,
              reference_date: be_a(Time),
              custom: false
            )
            expect(HttpRequestLog.count).to eq(1)
          end
        end
      end

      context 'with invalid symbol' do
        let(:symbol) { 'INVALID' }

        it 'returns an empty hash' do
          VCR.use_cassette('asset_details/invalid_symbol') do
            result = asset_details

            expect(result).to be_nil
            expect(HttpRequestLog.count).to eq(1)
          end
        end
      end
    end

    context 'when searching for a mutual fund price' do
      context 'with valid symbol' do
        let(:symbol) { 'HGLG11' }

        it 'returns the mutual fund price' do
          VCR.use_cassette('asset_details/valid_mutual_fund') do
            result = asset_details

            expect(result).to be_a(Hash)
            expect(result).to include(
              code: 'HGLG11',
              kind: 'fii',
              business_name: 'FII CSHG Log',
              name: 'CSHG Logstica Fundo Investimento Imobiliario FII',
              price: 167.85,
              reference_date: be_a(Time),
              custom: false
            )
            expect(HttpRequestLog.count).to eq(1)
          end
        end
      end

      context 'with invalid symbol' do
        let(:symbol) { 'INVALID' }

        it 'returns an empty hash' do
          VCR.use_cassette('asset_details/invalid_mutual_fund') do
            result = asset_details

            expect(result).to be_nil
            expect(HttpRequestLog.count).to eq(1)
          end
        end
      end
    end

    context 'when http request fails' do
      let(:symbol) { 'PETR4' }

      context 'when Faraday::TimeoutError is raised' do
        before do
          allow_any_instance_of(Faraday::Connection).to receive(:get).and_raise(Faraday::TimeoutError)
        end

        it 'raises an AlphaVantage::TimeoutError' do
          expect(asset_details).to be_nil
          expect(HttpRequestLog.count).to eq(1)
        end
      end

      context 'when Faraday::ConnectionFailed is raised' do
        before do
          allow_any_instance_of(Faraday::Connection).to receive(:get).and_raise(Faraday::ConnectionFailed)
        end

        it 'raises an AlphaVantage::ConnectionFailedError' do
          expect(asset_details).to be_nil
          expect(HttpRequestLog.count).to eq(1)
        end
      end

      context 'when Faraday::ClientError is raised' do
        before do
          allow_any_instance_of(Faraday::Connection).to receive(:get).and_raise(Faraday::ClientError)
        end

        it 'raises an AlphaVantage::ClientError' do
          expect(asset_details).to be_nil
          expect(HttpRequestLog.count).to eq(1)
        end
      end

      context 'when Faraday::ServerError is raised' do
        before do
          allow_any_instance_of(Faraday::Connection).to receive(:get).and_raise(Faraday::ServerError)
        end

        it 'raises an AlphaVantage::ServerError' do
          expect(asset_details).to be_nil
          expect(HttpRequestLog.count).to eq(1)
        end
      end
    end
  end
end
