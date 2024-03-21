# frozen_string_literal: true

# CoreStocks APIs integration
  module AlphaVantage 
    class CoreStocks < Base
      def symbol_search(keywords:)
        get(params: { function: 'SYMBOL_SEARCH', keywords: keywords })
      end 

      def time_series_daily_adjusted(symbol:)
        get(params: { function: 'TIME_SERIES_DAILY_ADJUSTED', symbol: symbol })
      end

      def global_quote(symbol:)
        get(params: { function: 'GLOBAL_QUOTE', symbol: symbol })
      end
    end
  end