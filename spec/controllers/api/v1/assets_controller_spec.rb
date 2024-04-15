require 'rails_helper'

RSpec.describe Api::V1::AssetsController, type: :controller do
  let(:user) { create(:user) }

  before do
    sign_in(user)
  end

  describe 'GET #index' do
    context 'when there are assets' do
      let!(:assets) { create_list(:asset, 3) }

      it 'returns a list of assets' do
        get :index

        expect(response).to be_successful
        expect(response.parsed_body.size).to eq(3)
      end
    end

    context 'when there are no assets' do
      it 'returns an empty list' do
        get :index

        expect(response).to be_successful
        expect(response.parsed_body.size).to eq(0)
      end
    end
  end

  describe 'GET #show' do
    context 'when the asset exists' do
      let(:asset) { create(:asset) }

      it 'returns the asset' do
        get :show, params: { id: asset.id }

        expect(response).to be_successful
        expect(response.parsed_body['id']).to eq(asset.id)
      end
    end

    context 'when the asset does not exist' do
      it 'returns a 404' do
        get :show, params: { id: 1 }

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'GET #search' do
    context 'when there are matching assets' do
      let!(:assets) { create(:asset, name: 'Bitcoin', code: 'BTC') }

      context 'when matching by asset name' do
        it 'returns a list of assets' do
          get :search, params: { asset: 'bitcoin' }

          expect(response).to be_successful
          expect(response.parsed_body.size).to eq(1)
        end
      end

      context 'when matching by asset identifier' do
        it 'returns a list of assets' do
          get :search, params: { asset: 'btc' }

          expect(response).to be_successful
          expect(response.parsed_body.size).to eq(1)
        end
      end
    end

    context 'when there are no matching assets' do
      it 'returns an empty list' do
        get :search, params: { asset: 'Bitcoin' }

        expect(response).to be_successful
        expect(response.parsed_body.size).to eq(0)
      end
    end
  end

  describe 'GET #deep_search' do 
    it 'schedules an asset discovery job' do
      expect {
        get :deep_search, params: { asset: 'Bitcoin' }
      }.to change(AssetDiscoveryJob.jobs, :size).by(1)
    end

    it 'returns a success message' do
      get :deep_search, params: { asset: 'Bitcoin' }

      expect(response).to be_successful
      expect(response.parsed_body['message']).to eq('Asset discovery job has been scheduled')
    end
  end
end
