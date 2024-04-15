class OutdatedAssetPriceError < StandardError
  attr_reader :asset

  def initialize(asset:)
    @asset = asset
    super("Asset with id: #{asset.id} has only outdated prices")
  end
end
