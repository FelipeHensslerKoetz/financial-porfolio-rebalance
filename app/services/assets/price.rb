module Assets
  class Price
    attr_reader :asset, :output_currency

    def self.call(asset:, output_currency:)
      new(asset:, output_currency:).call
    end

    def initialize(asset:, output_currency:)
      @asset = asset
      @output_currency = output_currency
    end

    def call
      validate_arguments
      validate_any_asset_prices_up_to_date
      validate_any_currency_parities_trackers_up_to_date

      average_price(all_converted_asset_prices)
    end

    private

    def validate_arguments
      raise ArgumentError, 'asset argument must be an Asset' unless asset.is_a?(Asset)
      raise ArgumentError, 'output_currency argument must be a Currency' unless output_currency.is_a?(Currency)
    end

    def validate_any_asset_prices_up_to_date
      return if up_to_date_asset_prices.any?

      raise OutdatedAssetPriceError.new(asset:)
    end

    def validate_any_currency_parities_trackers_up_to_date
      return if all_prices_in_output_currency?

      currencies_to.each do |currency_to|
        next if currency_to == output_currency

        currency_parity = currency_parities.find_by(currency_from: output_currency, currency_to:)

        raise MissingCurrencyParityError.new(currency_from: output_currency, currency_to:) if currency_parity.blank?
        raise OutdatedCurrencyParityError.new(currency_parity:) unless currency_parity.up_to_date?
      end
    end

    def all_prices_in_output_currency?
      currencies_to.all? { |currency_to| currency_to == output_currency }
    end

    def up_to_date_asset_prices
      @up_to_date_asset_prices ||= asset.asset_prices.up_to_date
    end

    def currency_parities
      @currency_parities ||= CurrencyParity.where(currency_from: output_currency,
                                                  currency_to: currencies_to)
    end

    def currencies_to
      @currencies_to ||= up_to_date_asset_prices.map(&:currency).uniq
    end

    def all_converted_asset_prices
      up_to_date_asset_prices.map do |asset_price|
        converted_asset_prices(asset_price)
      end.flatten
    end

    def converted_asset_prices(asset_price)
      return asset_price.price if asset_price.currency == output_currency

      currency_parity = currency_parities.find_by(currency_to: asset_price.currency)

      currency_parity_trackers = currency_parity.currency_parity_trackers.up_to_date

      currency_parity_trackers.map do |currency_parity_tracker|
        asset_price.price.to_d / currency_parity_tracker.exchange_rate.to_d
      end
    end

    def average_price(prices)
      prices.sum.to_d / prices.size.to_d
    end
  end
end
