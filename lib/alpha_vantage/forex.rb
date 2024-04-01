module AlphaVantage
  class Forex < AlphaVantage::Base
    def currency_exchange_rate(from_currency:, to_currency:)
      get(params: { function: 'CURRENCY_EXCHANGE_RATE', from_currency:,
                    to_currency: })
    end
  end
end
