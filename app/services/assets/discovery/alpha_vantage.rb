module Assets
  module Discovery
    class AlphaVantage
      attr_reader :keywords, :partner_resource

      def self.call(keywords:)
        new(keywords:).call
      end

      def initialize(keywords:)
        @keywords = keywords
        @partner_resource = PartnerResource.find_by!(name: 'Alpha Vantage - Global Quote')
      end

      def call
        alpha_vantage_assets.map do |alpha_vantage_asset|
          asset = Asset.global.find_by(code: alpha_vantage_asset[:code])

          next if asset_already_discovered?(asset)

          if asset.present?
            create_asset_price(asset, alpha_vantage_asset)
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
          create_asset_price(@new_asset, alpha_vantage_asset)
        end

        @new_asset
      end

      def create_asset_price(asset, alpha_vantage_asset)
        asset_price_details ||= fetch_asset_price(alpha_vantage_asset[:alpha_vantage_code])

        AssetPrice.create!(
          code: alpha_vantage_asset[:alpha_vantage_code],
          asset:,
          partner_resource:,
          price: asset_price_details[:price],
          currency: fetch_currency(alpha_vantage_asset[:currency]),
          last_sync_at: Time.zone.now,
          reference_date: asset_price_details[:reference_date]
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
        asset.present? && asset.asset_prices.any? do |asset_price|
          asset_price.partner_resource == @partner_resource
        end
      end

      def alpha_vantage_assets
        @alpha_vantage_assets ||= ::AlphaVantage::CoreStocks.symbol_search(keywords:)
      end
    end
  end
end
