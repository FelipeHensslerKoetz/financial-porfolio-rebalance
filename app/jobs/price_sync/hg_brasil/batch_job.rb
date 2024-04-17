module PriceSync
  module HgBrasil
    class BatchJob
      include Sidekiq::Job

      sidekiq_options queue: 'price_sync_hg_brasil_batch', retry: false

      def perform(asset_symbols)
        PriceSync::HgBrasil::BatchService.new(asset_symbols:).call
      end
    end
  end
end
