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
end
