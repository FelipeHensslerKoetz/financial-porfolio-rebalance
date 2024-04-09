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
        alpha_vantage_assets_params.map do |asset_params|
          asset = Asset.global.find_by(code: asset_params[:code])

          next if asset_already_discovered?(asset)

          if asset.present?
            create_asset_price_tracker(asset, asset_params)
            asset
          else
            create_asset(asset_params)
          end
        end.compact
      end

      private

      def create_asset(asset_params)
        ActiveRecord::Base.transaction do
          @new_asset = Asset.create!(asset_params.except(:alpha_vantage_code,
                                                         :currency))
          create_asset_price_tracker(@new_asset, asset_params)
        end

        @new_asset
      end

      def create_asset_price_tracker(asset, asset_params)
        asset_price = fetch_asset_price(asset_params[:alpha_vantage_code])
        currency = fetch_currency(asset_params[:currency])

        AssetPriceTracker.create!(
          code: asset_params[:alpha_vantage_code],
          asset:,
          data_origin:,
          price: asset_price,
          currency:,
          last_sync_at: Time.zone.now
        )
      end

      # TODO: treat exception
      def fetch_asset_price(alpha_vantage_code)
        ::AlphaVantage::CoreStocks.new.global_quote(symbol: alpha_vantage_code)&.dig('Global Quote', '05. price')
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
        @alpha_vantage_assets ||= ::AlphaVantage::CoreStocks.new.symbol_search(keywords:)&.dig('bestMatches') || []
      end

      def alpha_vantage_assets_params
        alpha_vantage_assets.map do |asset|
          {
            alpha_vantage_code: asset['1. symbol'],
            code: asset['1. symbol'].split('.').first.upcase,
            kind: asset['3. type'],
            name: asset['2. name'],
            business_name: asset['2. name'],
            region: asset['4. region'],
            market_time: {
              'open' => asset['5. marketOpen'],
              'close' => asset['6. marketClose'],
              'timezone' => asset['7. timezone']
            },
            custom: false,
            currency: asset['8. currency']
          }
        end
      end
    end
  end
end
