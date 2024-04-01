require 'rails_helper'

RSpec.describe AlphaVantage::CoreStocks do
  describe '#symbol_search' do
    context 'when the request is successful' do
      context 'when request returns a single match' do
        it 'returns the search results' do
          VCR.use_cassette('alpha_vantage/symbol_search_success_unique') do
            response = described_class.new.symbol_search(keywords: 'petr4')

            expect(response).to eq(
              { 'bestMatches' => [
                {
                  '1. symbol' => 'PETR4.SAO',
                  '2. name' => 'Petróleo Brasileiro S.A. - Petrobras',
                  '3. type' => 'Equity',
                  '4. region' => 'Brazil/Sao Paolo',
                  '5. marketOpen' => '10:00',
                  '6. marketClose' => '17:30',
                  '7. timezone' => 'UTC-03',
                  '8. currency' => 'BRL',
                  '9. matchScore' => '0.7692'
                }
              ] }
            )
            expect(HttpRequestLog.count).to eq(1)
          end
        end
      end

      context 'when request returns multiple matches' do
        it 'returns the search results' do
          VCR.use_cassette('alpha_vantage/symbol_search_success_multiple') do
            response = described_class.new.symbol_search(keywords: 'bitcoin')

            expect(response).to eq(
              {
                'bestMatches' => [
                  {
                    '1. symbol' => 'EBIT-U.TRT',
                    '2. name' => 'Bitcoin ETF',
                    '3. type' => 'ETF',
                    '4. region' => 'Toronto',
                    '5. marketOpen' => '09:30',
                    '6. marketClose' => '16:00',
                    '7. timezone' => 'UTC-05',
                    '8. currency' => 'CAD',
                    '9. matchScore' => '0.7778'
                  },
                  {
                    '1. symbol' => 'EBIT.TRT',
                    '2. name' => 'Bitcoin ETF CAD',
                    '3. type' => 'ETF',
                    '4. region' => 'Toronto',
                    '5. marketOpen' => '09:30',
                    '6. marketClose' => '16:00',
                    '7. timezone' => 'UTC-05',
                    '8. currency' => 'CAD',
                    '9. matchScore' => '0.6364'
                  },
                  {
                    '1. symbol' => 'ADE.DEX',
                    '2. name' => 'Bitcoin Group SE',
                    '3. type' => 'Equity',
                    '4. region' => 'XETRA',
                    '5. marketOpen' => '08:00',
                    '6. marketClose' => '20:00',
                    '7. timezone' => 'UTC+02',
                    '8. currency' => 'EUR',
                    '9. matchScore' => '0.6087'
                  },
                  {
                    '1. symbol' => 'ADE.FRK',
                    '2. name' => 'Bitcoin Group SE',
                    '3. type' => 'Equity',
                    '4. region' => 'Frankfurt',
                    '5. marketOpen' => '08:00',
                    '6. marketClose' => '20:00',
                    '7. timezone' => 'UTC+02',
                    '8. currency' => 'EUR',
                    '9. matchScore' => '0.6087'
                  },
                  {
                    '1. symbol' => 'BTGGF',
                    '2. name' => 'Bitcoin Group SE',
                    '3. type' => 'Equity',
                    '4. region' => 'United States',
                    '5. marketOpen' => '09:30',
                    '6. marketClose' => '16:00',
                    '7. timezone' => 'UTC-04',
                    '8. currency' => 'USD',
                    '9. matchScore' => '0.6087'
                  },
                  {
                    '1. symbol' => 'BTM',
                    '2. name' => 'Bitcoin Depot Inc',
                    '3. type' => 'Equity',
                    '4. region' => 'United States',
                    '5. marketOpen' => '09:30',
                    '6. marketClose' => '16:00',
                    '7. timezone' => 'UTC-04',
                    '8. currency' => 'USD',
                    '9. matchScore' => '0.5833'
                  },
                  {
                    '1. symbol' => 'QBTC.TRT',
                    '2. name' => 'Bitcoin Fund Unit',
                    '3. type' => 'Equity',
                    '4. region' => 'Toronto',
                    '5. marketOpen' => '09:30',
                    '6. marketClose' => '16:00',
                    '7. timezone' => 'UTC-05',
                    '8. currency' => 'CAD',
                    '9. matchScore' => '0.5833'
                  },
                  {
                    '1. symbol' => 'BTGN',
                    '2. name' => 'Bitcoin Generation Inc',
                    '3. type' => 'Equity',
                    '4. region' => 'United States',
                    '5. marketOpen' => '09:30',
                    '6. marketClose' => '16:00',
                    '7. timezone' => 'UTC-04',
                    '8. currency' => 'USD',
                    '9. matchScore' => '0.5455'
                  },
                  {
                    '1. symbol' => 'BTMWW',
                    '2. name' => 'Bitcoin Depot Inc Warrant',
                    '3. type' => 'Equity',
                    '4. region' => 'United States',
                    '5. marketOpen' => '09:30',
                    '6. marketClose' => '16:00',
                    '7. timezone' => 'UTC-04',
                    '8. currency' => 'USD',
                    '9. matchScore' => '0.4375'
                  },
                  {
                    '1. symbol' => 'BTEUF',
                    '2. name' => 'Bitcoin ETF ( USD Unhedged Units)',
                    '3. type' => 'ETF',
                    '4. region' => 'United States',
                    '5. marketOpen' => '09:30',
                    '6. marketClose' => '16:00',
                    '7. timezone' => 'UTC-04',
                    '8. currency' => 'USD',
                    '9. matchScore' => '0.3500'
                  }
                ]
              }
            )
            expect(HttpRequestLog.count).to eq(1)
          end
        end
      end

      context 'when request returns no matches' do
        it 'returns an empty array' do
          VCR.use_cassette('alpha_vantage/symbol_search_success_empty') do
            response = described_class.new.symbol_search(keywords: 'koetz')

            expect(response).to eq({ 'bestMatches' => [] })
            expect(HttpRequestLog.count).to eq(1)
          end
        end
      end
    end

    context 'when the request is not successful' do
      context 'when Faraday::TimeoutError is raised' do
        it 'raises an AlphaVantage::TimeoutError' do
          allow_any_instance_of(Faraday::Connection).to receive(:get).and_raise(Faraday::TimeoutError)

          response = described_class.new.symbol_search(keywords: 'petr4')

          expect(response).to be_nil
          expect(HttpRequestLog.count).to eq(1)
        end
      end

      context 'when Faraday::ConnectionFailed is raised' do
        it 'raises an AlphaVantage::ConnectionFailedError' do
          allow_any_instance_of(Faraday::Connection).to receive(:get).and_raise(Faraday::ConnectionFailed)

          response = described_class.new.symbol_search(keywords: 'petr4')

          expect(response).to be_nil
          expect(HttpRequestLog.count).to eq(1)
        end
      end

      context 'when Faraday::ClientError is raised' do
        it 'raises an AlphaVantage::ClientError' do
          allow_any_instance_of(Faraday::Connection).to receive(:get).and_raise(Faraday::ClientError)

          response = described_class.new.symbol_search(keywords: 'petr4')

          expect(response).to be_nil
          expect(HttpRequestLog.count).to eq(1)
        end
      end

      context 'when Faraday::ServerError is raised' do
        it 'raises an AlphaVantage::ServerError' do
          allow_any_instance_of(Faraday::Connection).to receive(:get).and_raise(Faraday::ServerError)

          response = described_class.new.symbol_search(keywords: 'petr4')

          expect(response).to be_nil
          expect(HttpRequestLog.count).to eq(1)
        end
      end

      context 'when Faraday::ParsingError is raised' do
        it 'raises an AlphaVantage::ParsingError' do
          allow_any_instance_of(Faraday::Connection).to receive(:get).and_raise(Faraday::ParsingError)

          response = described_class.new.symbol_search(keywords: 'petr4')

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
            response = described_class.new.global_quote(symbol: 'PETR4.SAO')

            expect(response).to eq(
              {
                'Global Quote' => {
                  '01. symbol' => 'PETR4.SAO',
                  '02. open' => '36.8500',
                  '03. high' => '37.0600',
                  '04. low' => '35.6800',
                  '05. price' => '35.7000',
                  '06. volume' => '46900700',
                  '07. latest trading day' => '2024-03-21',
                  '08. previous close' => '36.7000',
                  '09. change' => '-1.0000',
                  '10. change percent' => '-2.7248%'
                }
              }
            )
            expect(HttpRequestLog.count).to eq(1)
          end
        end
      end

      context 'when request returns no match' do
        it 'returns an empty hash' do
          VCR.use_cassette('alpha_vantage/global_quote_success_empty') do
            response = described_class.new.global_quote(symbol: 'FELIPE.KOETZ')

            expect(response).to eq({ 'Global Quote' => {} })
            expect(HttpRequestLog.count).to eq(1)
          end
        end
      end
    end

    context 'when the request is not successful' do
      context 'when Faraday::TimeoutError is raised' do
        it 'raises an AlphaVantage::TimeoutError' do
          allow_any_instance_of(Faraday::Connection).to receive(:get).and_raise(Faraday::TimeoutError)

          response = described_class.new.global_quote(symbol: 'PETR4.SAO')

          expect(response).to be_nil
          expect(HttpRequestLog.count).to eq(1)
        end
      end

      context 'when Faraday::ConnectionFailed is raised' do
        it 'raises an AlphaVantage::ConnectionFailedError' do
          allow_any_instance_of(Faraday::Connection).to receive(:get).and_raise(Faraday::ConnectionFailed)

          response = described_class.new.global_quote(symbol: 'PETR4.SAO')

          expect(response).to be_nil
          expect(HttpRequestLog.count).to eq(1)
        end
      end

      context 'when Faraday::ClientError is raised' do
        it 'raises an AlphaVantage::ClientError' do
          allow_any_instance_of(Faraday::Connection).to receive(:get).and_raise(Faraday::ClientError)

          response = described_class.new.global_quote(symbol: 'PETR4.SAO')

          expect(response).to be_nil
          expect(HttpRequestLog.count).to eq(1)
        end
      end

      context 'when Faraday::ServerError is raised' do
        it 'raises an AlphaVantage::ServerError' do
          allow_any_instance_of(Faraday::Connection).to receive(:get).and_raise(Faraday::ServerError)

          response = described_class.new.global_quote(symbol: 'PETR4.SAO')

          expect(response).to be_nil
          expect(HttpRequestLog.count).to eq(1)
        end
      end
    end
  end
end
