# frozen_string_literal: true

# CoreStocks APIs integration
module AlphaVantage
  # CoreStocks class
  class CoreStocks < AlphaVantage::Base
    def self.symbol_search(keywords:)
      new.symbol_search(keywords:)
    end

    def self.global_quote(symbol:)
      new.global_quote(symbol:)
    end

    def symbol_search(keywords:)
      response ||= get(params: { function: 'SYMBOL_SEARCH', keywords: })
      best_matches = response&.dig('bestMatches')

      return nil unless best_matches.is_a?(Array)

      best_matches.map do |match|
        {
          alpha_vantage_code: match['1. symbol'],
          code: match['1. symbol'].split('.').first.upcase,
          name: match['2. name'],
          business_name: match['2. name'],
          kind: match['3. type'],
          currency: match['8. currency'],
          custom: false
        }
      end
    end

    def global_quote(symbol:)
      response ||= get(params: { function: 'GLOBAL_QUOTE', symbol: })

      price = response&.dig('Global Quote', '05. price')
      reference_date = response&.dig('Global Quote', '07. latest trading day')

      return nil if price.nil? || reference_date.nil?

      {
        price: price.to_f,
        reference_date: Time.zone.parse(reference_date)
      }
    end
  end
end
