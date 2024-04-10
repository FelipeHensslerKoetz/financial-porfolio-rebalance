module Assets
  module Discovery
    class AlphaVantage
      attr_reader :keywords, :data_origin

      def self.call(keywords:)
        new(keywords:).call
      end

      def initialize(keywords:)
        @keywords = keywords
        @data_origin = DataOrigin.find_by!(name: 'Alpha Vantage')
      end

      def call
        alpha_vantage_assets.map do |alpha_vantage_asset|
          asset = Asset.global.find_by(code: alpha_vantage_asset[:code])

          next if asset_already_discovered?(asset)

          if asset.present?
            create_asset_price_tracker(asset, alpha_vantage_asset)
            asset
          else
            create_asset(alpha_vantage_asset)
          end
        end.compact
      end

      private

      def create_asset(alpha_vantage_asset)
        ActiveRecord::Base.transaction do
          @new_asset = Asset.create!(alpha_vantage_asset.except(:alpha_vantage_code, :currency))
          create_asset_price_tracker(@new_asset, alpha_vantage_asset)
        end

        @new_asset
      end

      def create_asset_price_tracker(asset, alpha_vantage_asset)
        asset_price_details = fetch_asset_price(alpha_vantage_asset[:alpha_vantage_code])
        price = asset_price_details[:price]
        reference_date = asset_price_details[:reference_date]
        currency = fetch_currency(alpha_vantage_asset[:currency])

        AssetPriceTracker.create!(
          code: alpha_vantage_asset[:alpha_vantage_code],
          asset:,
          data_origin:,
          price:,
          currency:,
          last_sync_at: Time.zone.now,
          reference_date:
        )
      end

      # TODO: treat exception
      def fetch_asset_price(alpha_vantage_code)
        ::AlphaVantage::CoreStocks.new.global_quote(symbol: alpha_vantage_code)
      end

      def fetch_currency(currency_code)
        Currency.find_by!(code: currency_code)
      end

      def asset_already_discovered?(asset)
        asset.present? && asset.asset_price_trackers.any? do |asset_price_tracker|
          asset_price_tracker.data_origin == @data_origin
        end
      end

      # TODO: treat exception
      def alpha_vantage_assets
        @alpha_vantage_assets ||= ::AlphaVantage::CoreStocks.symbol_search(keywords:)
      end
    end
  end
end
