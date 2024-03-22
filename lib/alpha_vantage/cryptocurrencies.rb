module AlphaVantage
  class Cryptocurrencies < AlphaVantage::Base
    def currency_exchange_rate(from_currency:, to_currency:)
      get(params: { function: 'CURRENCY_EXCHANGE_RATE', from_currency:,
                    to_currency: })['data']
    end
  end
end
