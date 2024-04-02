module Assets
  module Discovery
    class HgBrasil
      attr_reader :symbol

      def self.call(symbol:)
        new(symbol:).call
      end

      def initialize(symbol:)
        @symbol = symbol&.upcase
      end

      def call
        [formatted_asset_attributes].compact
      end

      private

      def asset
        @asset ||= ::HgBrasil::Stocks.new.stock_price(symbol:)&.dig('results', symbol.to_s.upcase)
      end

      def formatted_asset_attributes
        return if asset.blank? || asset['error']

        {
          code: asset['symbol'].upcase,
          kind: asset['kind'],
          business_name: asset['name'],
          name: asset['company_name'],
          document: asset['document'],
          description: asset['description'],
          website: asset['website'],
          sector: asset['sector'],
          region: asset['region'],
          market_time: asset['market_time'],
          logo: asset['logo']
        }
      end
    end
  end
end
