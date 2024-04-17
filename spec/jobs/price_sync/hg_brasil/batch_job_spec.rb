require 'rails_helper'

RSpec.describe PriceSync::HgBrasil::BatchJob, type: :job do
  describe 'sidekiq_options' do
    it 'sets the queue to price_sync_hg_brasil_batch' do
      expect(described_class.get_sidekiq_options['queue']).to eq('price_sync_hg_brasil_batch')
    end

    it 'sets the retry option to false' do
      expect(described_class.get_sidekiq_options['retry']).to eq(false)
    end
  end

  describe 'includes' do
    it 'includes Sidekiq::Job' do
      expect(described_class.ancestors).to include(Sidekiq::Job)
    end
  end

  describe '#perform' do
    subject(:batch_job) { described_class.new }

    let(:asset_symbols) { 'symbol1,symbol2,symbol3,symbol4,symbol5' }
    let(:batch_service_instance) { instance_double(PriceSync::HgBrasil::BatchService, call: true) }

    before do
      allow(PriceSync::HgBrasil::BatchService).to receive(:new).and_return(batch_service_instance)
      batch_job.perform(asset_symbols)
    end

    it 'calls PriceSync::HgBrasil::BatchService.new with the asset_symbols' do
      expect(PriceSync::HgBrasil::BatchService).to have_received(:new).with(asset_symbols:).once
      expect(batch_service_instance).to have_received(:call).once
    end
  end
end
