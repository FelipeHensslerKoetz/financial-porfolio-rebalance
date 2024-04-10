require 'rails_helper'

RSpec.describe AlphaVantage::CoreStocks do
  describe '#symbol_search' do
    context 'when the request is successful' do
      context 'when request returns a single match' do
        it 'returns the search results' do
          VCR.use_cassette('alpha_vantage/symbol_search_success_unique') do
            response = described_class.symbol_search(keywords: 'petr4')

            expect(HttpRequestLog.count).to eq(1)
          end
        end
      end

      context 'when request returns multiple matches' do
        it 'returns the search results' do
          VCR.use_cassette('alpha_vantage/symbol_search_success_multiple') do
            response = described_class.symbol_search(keywords: 'bitcoin')

            expect(response).to include(
                  {
                    alpha_vantage_code: 'EBIT-U.TRT',
                    code: 'EBIT-U',
                    name: 'Bitcoin ETF',
                    business_name: 'Bitcoin ETF',
                    kind: 'ETF',
                    currency: 'CAD',
                    custom: false
                  },
                  {
                    alpha_vantage_code: 'EBIT.TRT',
                    code: 'EBIT',
                    name: 'Bitcoin ETF CAD',
                    business_name: 'Bitcoin ETF CAD',
                    kind: 'ETF',
                    currency: 'CAD',
                    custom: false
                  },
                  {
                    alpha_vantage_code: 'ADE.DEX',
                    code: 'ADE',
                    name: 'Bitcoin Group SE',
                    business_name: 'Bitcoin Group SE',
                    kind: 'Equity',
                    currency: 'EUR',
                    custom: false
                  },
                  {
                    alpha_vantage_code: 'ADE.FRK',
                    code: 'ADE',
                    name: 'Bitcoin Group SE',
                    business_name: 'Bitcoin Group SE',
                    kind: 'Equity',
                    currency: 'EUR',
                    custom: false
                  },
                  {
                    alpha_vantage_code: 'BTGGF',
                    code: 'BTGGF',
                    name: 'Bitcoin Group SE',
                    business_name: 'Bitcoin Group SE',
                    kind: 'Equity',
                    currency: 'USD',
                    custom: false
                  },
                  {
                    alpha_vantage_code: 'BTM',
                    code: 'BTM',
                    name: 'Bitcoin Depot Inc',
                    business_name: 'Bitcoin Depot Inc',
                    kind: 'Equity',
                    currency: 'USD',
                    custom: false
                  },
                  {
                    alpha_vantage_code: 'QBTC.TRT',
                    code: 'QBTC',
                    name: 'Bitcoin Fund Unit',
                    business_name: 'Bitcoin Fund Unit',
                    kind: 'Equity',
                    currency: 'CAD',
                    custom: false
                  },
                  {
                    alpha_vantage_code: 'BTGN',
                    code: 'BTGN',
                    name: 'Bitcoin Generation Inc',
                    business_name: 'Bitcoin Generation Inc',
                    kind: 'Equity',
                    currency: 'USD',
                    custom: false
                  },
                  {
                    alpha_vantage_code: 'BTMWW',
                    code: 'BTMWW',
                    name: 'Bitcoin Depot Inc Warrant',
                    business_name: 'Bitcoin Depot Inc Warrant',
                    kind:  'Equity',
                    currency: 'USD',
                    custom: false
                  },
                  {
                    alpha_vantage_code: 'BTEUF',
                    code: 'BTEUF',
                    name: 'Bitcoin ETF ( USD Unhedged Units)',
                    business_name: 'Bitcoin ETF ( USD Unhedged Units)',
                    kind: 'ETF',
                    currency: 'USD',
                    custom: false
                  }
            )
            expect(HttpRequestLog.count).to eq(1)
          end
        end
      end

      context 'when request returns no matches' do
        it 'returns an empty array' do
          VCR.use_cassette('alpha_vantage/symbol_search_success_empty') do
            response = described_class.symbol_search(keywords: 'koetz')

            expect(response).to eq([])
            expect(HttpRequestLog.count).to eq(1)
          end
        end
      end
    end

    context 'when the request is not successful' do
      context 'when Faraday::TimeoutError is raised' do
        it 'raises an AlphaVantage::TimeoutError' do
          allow_any_instance_of(Faraday::Connection).to receive(:get).and_raise(Faraday::TimeoutError)

          response = described_class.symbol_search(keywords: 'petr4')

          expect(response).to be_nil
          expect(HttpRequestLog.count).to eq(1)
        end
      end

      context 'when Faraday::ConnectionFailed is raised' do
        it 'raises an AlphaVantage::ConnectionFailedError' do
          allow_any_instance_of(Faraday::Connection).to receive(:get).and_raise(Faraday::ConnectionFailed)

          response = described_class.symbol_search(keywords: 'petr4')

          expect(response).to be_nil
          expect(HttpRequestLog.count).to eq(1)
        end
      end

      context 'when Faraday::ClientError is raised' do
        it 'raises an AlphaVantage::ClientError' do
          allow_any_instance_of(Faraday::Connection).to receive(:get).and_raise(Faraday::ClientError)

          response = described_class.symbol_search(keywords: 'petr4')

          expect(response).to be_nil
          expect(HttpRequestLog.count).to eq(1)
        end
      end

      context 'when Faraday::ServerError is raised' do
        it 'raises an AlphaVantage::ServerError' do
          allow_any_instance_of(Faraday::Connection).to receive(:get).and_raise(Faraday::ServerError)

          response = described_class.symbol_search(keywords: 'petr4')

          expect(response).to be_nil
          expect(HttpRequestLog.count).to eq(1)
        end
      end

      context 'when Faraday::ParsingError is raised' do
        it 'raises an AlphaVantage::ParsingError' do
          allow_any_instance_of(Faraday::Connection).to receive(:get).and_raise(Faraday::ParsingError)

          response = described_class.symbol_search(keywords: 'petr4')

          expect(response).to be_nil
          expect(HttpRequestLog.count).to eq(1)
        end
      end
    end
  end

  describe '#global_quote' do
    context 'when the request is successful' do
      context 'when request returns a match' do
        it 'returns the search results' do
          VCR.use_cassette('alpha_vantage/global_quote_success') do
            response = described_class.global_quote(symbol: 'PETR4.SAO')

            expect(response).to include(
              {
                price: be_a(Float),
                reference_date: be_a(Time)
              }
            )
            expect(HttpRequestLog.count).to eq(1)
          end
        end
      end

      context 'when request returns no match' do
        it 'returns an empty hash' do
          VCR.use_cassette('alpha_vantage/global_quote_success_empty') do
            response = described_class.global_quote(symbol: 'FELIPE.KOETZ')

            expect(response).to be_nil
            expect(HttpRequestLog.count).to eq(1)
          end
        end
      end
    end

    context 'when the request is not successful' do
      context 'when Faraday::TimeoutError is raised' do
        it 'raises an AlphaVantage::TimeoutError' do
          allow_any_instance_of(Faraday::Connection).to receive(:get).and_raise(Faraday::TimeoutError)

          response = described_class.global_quote(symbol: 'PETR4.SAO')

          expect(response).to be_nil
          expect(HttpRequestLog.count).to eq(1)
        end
      end

      context 'when Faraday::ConnectionFailed is raised' do
        it 'raises an AlphaVantage::ConnectionFailedError' do
          allow_any_instance_of(Faraday::Connection).to receive(:get).and_raise(Faraday::ConnectionFailed)

          response = described_class.global_quote(symbol: 'PETR4.SAO')

          expect(response).to be_nil
          expect(HttpRequestLog.count).to eq(1)
        end
      end

      context 'when Faraday::ClientError is raised' do
        it 'raises an AlphaVantage::ClientError' do
          allow_any_instance_of(Faraday::Connection).to receive(:get).and_raise(Faraday::ClientError)

          response = described_class.global_quote(symbol: 'PETR4.SAO')

          expect(response).to be_nil
          expect(HttpRequestLog.count).to eq(1)
        end
      end

      context 'when Faraday::ServerError is raised' do
        it 'raises an AlphaVantage::ServerError' do
          allow_any_instance_of(Faraday::Connection).to receive(:get).and_raise(Faraday::ServerError)

          response = described_class.global_quote(symbol: 'PETR4.SAO')

          expect(response).to be_nil
          expect(HttpRequestLog.count).to eq(1)
        end
      end
    end
  end
end
