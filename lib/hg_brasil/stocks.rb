module HgBrasil
  class Stocks < HgBrasil::Base
    def self.asset_details(symbol:)
      new.asset_details(symbol:)
    end

    def asset_details(symbol:)
      response ||= get(url: '/stock_price', params: { symbol: })&.dig('results', symbol.upcase)

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

    def asset_details_batch(symbols:)
      response ||= get(url: '/stock_price', params: { symbol: symbols.join(',') })&.dig('results')

      return nil if response.blank? || response['error'] || !response.is_a?(Hash)

      formatted_response = []

      response.each_value do |value|
        next if value['error']

        formatted_response << {
          code: value['symbol'].upcase,
          kind: value['kind'],
          business_name: value['name'] || value['company_name'],
          name: value['company_name'] || value['name'],
          price: value['price'],
          reference_date: Time.zone.parse(value['updated_at']),
          currency: value['currency'],
          custom: false
        }
      end

      formatted_response
    end
  end
end
