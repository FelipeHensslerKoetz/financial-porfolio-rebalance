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
      validate_asset_price
      validate_currency_parity_exchange_rate

      price
    end

    private

    def validate_arguments
      raise ArgumentError, 'asset argument must be an Asset' unless asset.is_a?(Asset)
      raise ArgumentError, 'output_currency argument must be a Currency' unless output_currency.is_a?(Currency)
    end

    def validate_asset_price
      return if asset_price.present?

      raise OutdatedAssetPriceError.new(asset:)
    end

    def validate_currency_parity_exchange_rate
      return if input_currency == output_currency

      raise MissingCurrencyParityError.new(currency_from: output_currency, currency_to: input_currency) if currency_parity.blank?
      raise OutdatedCurrencyParityError.new(currency_parity:) unless currency_parity.up_to_date?
    end

    def asset_price
      @asset_price ||= asset.latest_asset_price
    end

    def currency_parity
      @currency_parity ||= CurrencyParity.find_by(currency_from: output_currency,
                                                  currency_to: input_currency)
    end

    def input_currency
      @input_currency ||= asset_price.currency
    end

    def currency_parity_exchange_rate
      @currency_parity_exchange_rate ||= currency_parity.latest_currency_parity_exchange_rate
    end

    def price
      return asset_price.price if input_currency == output_currency

      asset_price.price.to_d / currency_parity_exchange_rate.exchange_rate.to_d
    end
  end
end
