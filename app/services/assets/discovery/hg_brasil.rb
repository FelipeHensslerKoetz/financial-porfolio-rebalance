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
        if asset_already_discovered? || discovered_asset_attributes.blank?
          return
        end

        if existing_asset.present?
          create_asset_price_tracker(existing_asset)
          nil
        else
          create_asset
        end
      end

      private

      def asset_already_discovered?
        existing_asset.present? && existing_asset.asset_price_trackers.any? do |asset_price_tracker|
          asset_price_tracker.data_origin == data_origin
        end
      end

      def currency
        @currency ||= Currency.find_by!(code: asset['currency'])
      end

      def create_asset
        ActiveRecord::Base.transaction do
          @new_asset = Asset.create!(discovered_asset_attributes.except(:price))
          create_asset_price_tracker(@new_asset)
        end

        @new_asset
      rescue ActiveRecord::RecordInvalid => e
        Rails.logger.error("Error creating asset: #{e.message}")
        nil
      end

      def create_asset_price_tracker(target_asset)
        AssetPriceTracker.create!(asset: target_asset,
                                  data_origin:,
                                  price: discovered_asset_attributes[:price],
                                  last_sync_at: Time.zone.now,
                                  code: discovered_asset_attributes[:code],
                                  currency:)
      end

      # TODO: treat exception
      def asset
        @asset ||= ::HgBrasil::Stocks.new.stock_price(symbol:)&.dig('results', symbol)
      end

      def discovered_asset_attributes
        return if asset.blank? || asset['error']

        {
          code: asset['symbol'].upcase,
          kind: asset['kind'],
          business_name: asset['name'] || asset['company_name'],
          name: asset['company_name'] || asset['name'],
          document: asset['document'],
          description: asset['description'],
          website: asset['website'],
          sector: asset['sector'],
          region: asset['region'],
          market_time: asset['market_time'],
          image_path: asset['logo'],
          custom: false,
          price: asset['price']
        }
      end
    end
  end
end
