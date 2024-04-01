require 'rails_helper'

RSpec.describe AlphaVantage::Forex do
  describe '#currency_exchange_rate' do
    context 'when the request is successful' do
      context 'when the currencies codes are correct' do
        it 'returns the current exchange rate for the digital currency' do
          VCR.use_cassette('alpha_vantage/currency_exchange_rate_success') do
            response = described_class.new.currency_exchange_rate(from_currency: 'BTC',
                                                                  to_currency: 'BRL')

            expect(response).to eq(
              {
                'Realtime Currency Exchange Rate' =>
                  {
                    '1. From_Currency Code' => 'BTC',
                    '2. From_Currency Name' => 'Bitcoin',
                    '3. To_Currency Code' => 'BRL',
                    '4. To_Currency Name' => 'Brazilian Real',
                    '5. Exchange Rate' => '317189.86348000',
                    '6. Last Refreshed' => '2024-03-22 23:33:27',
                    '7. Time Zone' => 'UTC',
                    '8. Bid Price' => '317189.86348000',
                    '9. Ask Price' => '317189.91350900'
                  }
              }
            )

            expect(HttpRequestLog.count).to eq(1)
          end
        end
      end

      context 'when the currency code(s) are incorrect' do
        it 'returns an error message' do
          VCR.use_cassette('alpha_vantage/currency_exchange_rate_incorrect_currencies') do
            response = described_class.new.currency_exchange_rate(from_currency: 'ABC',
                                                                  to_currency: 'DEF')

            expect(response).to eq(
              {
                'Error Message' => 'Invalid API call. Please retry or visit the documentation (https://www.alphavantage.co/documentation/) for CURRENCY_EXCHANGE_RATE.'
              }
            )

            expect(HttpRequestLog.count).to eq(1)
          end
        end
      end
    end

    context 'when the request is not successful' do
      context 'when Faraday::TimeoutError is raised' do
        it 'raises an AlphaVantage::TimeoutError' do
          allow_any_instance_of(Faraday::Connection).to receive(:get).and_raise(Faraday::TimeoutError)

          response = described_class.new.currency_exchange_rate(
            from_currency: 'BTC', to_currency: 'BRL'
          )

          expect(response).to be_nil
          expect(HttpRequestLog.count).to eq(1)
        end
      end

      context 'when Faraday::ConnectionFailed is raised' do
        it 'raises an AlphaVantage::ConnectionFailedError' do
          allow_any_instance_of(Faraday::Connection).to receive(:get).and_raise(Faraday::ConnectionFailed)

          response = described_class.new.currency_exchange_rate(
            from_currency: 'BTC', to_currency: 'BRL'
          )

          expect(response).to be_nil
          expect(HttpRequestLog.count).to eq(1)
        end
      end

      context 'when Faraday::ClientError is raised' do
        it 'raises an AlphaVantage::ClientError' do
          allow_any_instance_of(Faraday::Connection).to receive(:get).and_raise(Faraday::ClientError)

          response = described_class.new.currency_exchange_rate(
            from_currency: 'BTC', to_currency: 'BRL'
          )

          expect(response).to be_nil
          expect(HttpRequestLog.count).to eq(1)
        end
      end

      context 'when Faraday::ServerError is raised' do
        it 'raises an AlphaVantage::ServerError' do
          allow_any_instance_of(Faraday::Connection).to receive(:get).and_raise(Faraday::ServerError)

          response = described_class.new.currency_exchange_rate(
            from_currency: 'BTC', to_currency: 'BRL'
          )

          expect(response).to be_nil
          expect(HttpRequestLog.count).to eq(1)
        end
      end
    end
  end
end
