module PriceSync
  module HgBrasil
    class BatchService
      attr_reader :data_origin, :asset_prices, :asset_symbols

      def self.call(asset_symbols:)
        new(asset_symbols:).call
      end

      def initialize(asset_symbols:)
        @asset_symbols = asset_symbols
        @data_origin = DataOrigin.find_by!(name: 'HG Brasil')
        @asset_prices = AssetPrice.where(code: @asset_symbols.split(','),
                                         data_origin: @data_origin)
      end

      def call
        asset_prices.each do |asset_price|
          next unless asset_price.may_process?

          asset_price.process!
          asset_price.success! if asset_price.update!(asset_details(asset_price.code))
        rescue StandardError
          # TODO: saver error message
          asset_price.fail!
          next
        end
      end

      private

      def fetch_asset_details_by_batch
        @fetch_asset_details_by_batch ||= ::HgBrasil::Stocks.asset_details_batch(symbols: asset_symbols)
      end

      def asset_details(code)
        asset_detail = fetch_asset_details_by_batch.detect { |asset| asset[:code] == code }

        {
          price: asset_detail.fetch(:price),
          reference_date: asset_detail.fetch(:reference_date)
        }
      end
    end
  end
end
