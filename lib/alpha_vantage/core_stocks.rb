# frozen_string_literal: true

# CoreStocks APIs integration
module AlphaVantage
  # CoreStocks class
  class CoreStocks < AlphaVantage::Base
    def symbol_search(keywords:)
      get(params: { function: 'SYMBOL_SEARCH', keywords: })
    end

    def global_quote(symbol:)
      get(params: { function: 'GLOBAL_QUOTE', symbol: })
    end
  end
end
