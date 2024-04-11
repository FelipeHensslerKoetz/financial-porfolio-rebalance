module Assets
  module Discovery
    class Global
      attr_reader :keywords

      def initialize(keywords:)
        @keywords = keywords
      end

      def call
        assets
      end

      private

      def assets
        @assets ||= [hg_brasil_asset].compact #+ [alpha_vantage_assets]).flatten.compact.uniq
      end

      def hg_brasil_asset
        @hg_brasil_asset ||= Assets::Discovery::HgBrasil.call(symbol: keywords)
      end

      def alpha_vantage_assets
        @alpha_vantage_assets ||= Assets::Discovery::AlphaVantage.call(keywords:)
      end
    end
  end
end
