module HgBrasil
  class Stocks < HgBrasil::Base
    def self.asset_details(symbol:)
      new.asset_details(symbol:)
    end

    def asset_details(symbol:)
      response = get(url: '/stock_price', params: { symbol: })&.dig('results', symbol.upcase)

      return nil if response.blank? || response['error']

      {
        code: response['symbol'].upcase,
        kind: response['kind'],
        business_name: response['name'] || response['company_name'],
        name: response['company_name'] || response['name'],
        price: response['price'],
        reference_date: Time.zone.parse(response['updated_at']),
        currency: response['currency'],
        custom: false
      }
    end
  end
end
