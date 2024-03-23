require 'rails_helper'

RSpec.describe Api::V1::CurrenciesController, type: :controller do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe 'GET /index' do
    context 'when there are currencies' do
      let!(:currencies) { create_list(:currency, 3) }

      it 'returns all currencies' do
        get :index

        expect(response).to have_http_status(:success)
        expect(response.parsed_body.size).to eq(3)
      end
    end

    context 'when there are no currencies' do
      it 'returns an empty array' do
        get :index

        expect(response).to have_http_status(:success)
        expect(response.parsed_body).to eq([])
      end
    end
  end

  describe 'GET /show' do
    context 'when the currency exists' do
      let!(:currency) { create(:currency) }

      it 'returns the currency' do
        get :show, params: { id: currency.id }

        expect(response).to have_http_status(:success)
        expect(response.parsed_body['id']).to eq(currency.id)
      end
    end

    context "when the currency doesn't exist" do
      it 'returns a not found status code' do
        get :show, params: { id: 0 }

        expect(response).to have_http_status(:not_found)
        expect(response.body).to eq('null')
      end
    end
  end
end
