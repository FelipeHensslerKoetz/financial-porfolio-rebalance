class AssetDiscoveryJob
  include Sidekiq::Job

  sidekiq_options queue: 'asset_discovery', retry: false

  def perform(keywords)
    Assets::Discovery::Global.new(keywords:).call
  end
end
