module Assets
  module Discovery
    class HgBrasil
      attr_reader :symbol, :data_origin, :existing_asset

      def self.call(symbol:)
        new(symbol:).call
      end

      def initialize(symbol:)
        @symbol = symbol&.upcase
        @data_origin = DataOrigin.find_by!(name: 'HG Brasil')
        @existing_asset = Asset.global.find_by('code LIKE :asset',
                                               asset: "%#{symbol}%")
      end

      def call
        return if skip_discovery?

        return create_asset if existing_asset.blank?

        create_asset_price(existing_asset)
      end

      private

      def skip_discovery?
        asset_already_discovered? || asset_details.blank?
      end

      def asset_already_discovered?
        existing_asset.present? && existing_asset.asset_prices.any? do |asset_price|
          asset_price.data_origin == data_origin
        end
      end

      def currency
        @currency ||= Currency.find_by!(code: asset_details[:currency])
      end

      def create_asset
        ActiveRecord::Base.transaction do
          @new_asset = Asset.create!(asset_details.except(:price, :reference_date, :currency))
          create_asset_price(@new_asset)
        end

        @new_asset
      rescue ActiveRecord::RecordInvalid => e
        Rails.logger.error("Error creating asset: #{e.message}")
        nil
      end

      def create_asset_price(target_asset)
        AssetPrice.create!(asset: target_asset,
                           data_origin:,
                           price: asset_details[:price],
                           last_sync_at: Time.zone.now,
                           code: asset_details[:code],
                           currency:,
                           reference_date: asset_details[:reference_date])
        nil
      end

      # TODO: treat exception
      def asset_details
        @asset_details ||= ::HgBrasil::Stocks.asset_details(symbol:)
      end
    end
  end
end
