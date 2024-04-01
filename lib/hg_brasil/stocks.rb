module HgBrasil
  class Stocks < HgBrasil::Base
    def stock_price(symbol:)
      get(url: '/stock_price', params: { symbol: })
    end
  end
end
