# frozen_string_literal: true

# CoreStocks APIs integration
module AlphaVantage
  # CoreStocks class
  class CoreStocks < AlphaVantage::Base
    def symbol_search(keywords:)
      get(params: { function: 'SYMBOL_SEARCH', keywords: })['data']
    end

    def time_series_daily_adjusted(symbol:)
      get(params: { function: 'TIME_SERIES_DAILY_ADJUSTED', symbol: })['data']
    end

    def global_quote(symbol:)
      get(params: { function: 'GLOBAL_QUOTE', symbol: })['data']
    end
  end
end
