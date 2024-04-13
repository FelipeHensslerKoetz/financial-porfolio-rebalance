require 'rails_helper'

RSpec.describe Api::V1::InvestmentPortfoliosController, type: :controller do
  let(:user) { create(:user) }

  let(:currency) { create(:currency, code: 'BRL') }
  let(:another_currency) { create(:currency, code: 'USD') }
  let(:asset) { create(:asset, code: 'PETR4') }
  let(:another_asset) { create(:asset, code: 'VALE3') }

  before { sign_in user }

  describe 'GET #index' do
    context 'when there are investment portfolios' do
      let!(:investment_portfolio) { create(:investment_portfolio, user:) }
      let!(:another_investment_portfolio) { create(:investment_portfolio, user:) }

      before { get :index, format: :json }

      it 'returns a list of investment portfolios' do
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(investment_portfolio.as_json(include: %i[investment_portfolio_assets user currency]).to_json,
                                         another_investment_portfolio.as_json(include: %i[investment_portfolio_assets user
                                                                                          currency]).to_json)
      end
    end

    context 'when there are no investment portfolios' do
      before { get :index, format: :json }

      it 'returns an empty list' do
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq([].to_json)
      end
    end
  end

  describe 'GET #show' do
    context 'when the investment portfolio exists' do
      context 'when the investment portfolio belongs to the user' do
        let(:investment_portfolio) { create(:investment_portfolio, user:) }

        before { get :show, params: { id: investment_portfolio.id }, format: :json }

        it 'returns the investment portfolio' do
          expect(response).to have_http_status(:ok)
          expect(response.body).to eq(investment_portfolio.as_json(include: %i[investment_portfolio_assets user currency]).to_json)
        end
      end

      context 'when the investment portfolio does not belong to the user' do
        let(:another_user) { create(:user) }
        let(:investment_portfolio) { create(:investment_portfolio, user: another_user) }

        before { get :show, params: { id: investment_portfolio.id }, format: :json }

        it 'does not return an investment portfolio' do
          expect(response).to have_http_status(:not_found)
          expect(response.body).to eq({ error: 'InvestmentPortfolio not found' }.to_json)
        end
      end
    end

    context 'when the investment portfolio does not exist' do
      before { get :show, params: { id: 0 }, format: :json }

      it 'returns a not found response' do
        expect(response).to have_http_status(:not_found)
        expect(response.body).to eq({ error: 'InvestmentPortfolio not found' }.to_json)
      end
    end
  end

  describe 'POST #create' do
    context 'when creation params are valid' do
      let(:investment_portfolio_params) do
        {
          investment_portfolio: {
            name: 'My Investment Portfolio',
            description: 'My first investment portfolio',
            currency_id: currency.id,
            investment_portfolio_assets_attributes: [
              {
                asset_id: asset.id,
                quantity: 100,
                allocation_weight: 100
              }
            ]
          }
        }
      end

      before { post :create, params: investment_portfolio_params, format: :json }

      it 'creates an investment portfolio and investment_portfolio_assets' do
        new_investment_portfolio = InvestmentPortfolio.last
        investment_portfolio_asset = new_investment_portfolio.investment_portfolio_assets.first

        expect(response).to have_http_status(:created)
        expect(response.body).to eq(new_investment_portfolio.as_json(include: %i[investment_portfolio_assets user currency]).to_json)
        expect(new_investment_portfolio.name).to eq('My Investment Portfolio')
        expect(new_investment_portfolio.description).to eq('My first investment portfolio')
        expect(new_investment_portfolio.currency).to eq(currency)
        expect(investment_portfolio_asset.asset).to eq(asset)
        expect(investment_portfolio_asset.quantity).to eq(100)
        expect(investment_portfolio_asset.allocation_weight).to eq(100)
        expect(InvestmentPortfolio.count).to eq(1)
        expect(InvestmentPortfolioAsset.count).to eq(1)
      end
    end

    context 'when creation params are invalid' do
      before { post :create, params: { investment_portfolio: {} }, format: :json }

      it 'does not create an investment portfolio' do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(InvestmentPortfolio.count).to eq(0)
        expect(InvestmentPortfolioAsset.count).to eq(0)
      end
    end
  end

  describe 'PATCH #update' do
    context 'when the investment portfolio exists' do
      context 'when the investment portfolio belongs to the user' do
        let(:investment_portfolio) { create(:investment_portfolio, user:) }

        let(:patch_call) do
          patch :update, params: { id: investment_portfolio.id, investment_portfolio: investment_portfolio_params }, format: :json
        end

        context 'when update params are valid' do
          context 'when creating a new investment_portfolio_asset' do
            let(:investment_portfolio_params) do
              {
                investment_portfolio_assets_attributes: [
                  {
                    asset_id: asset.id,
                    quantity: 250,
                    allocation_weight: 50
                  }
                ]
              }
            end

            before { patch_call }

            it 'creates a new investment_portfolio_asset' do
              investment_portfolio_asset = investment_portfolio.investment_portfolio_assets.first
              expect(response).to have_http_status(:ok)
              expect(investment_portfolio.reload.investment_portfolio_assets.count).to eq(1)
              expect(investment_portfolio_asset.attributes).to include(
                'asset_id' => asset.id,
                'quantity' => 250,
                'allocation_weight' => 50,
                'investment_portfolio_id' => investment_portfolio.id
              )
              expect(response.parsed_body).to eq(investment_portfolio.as_json(include: %i[investment_portfolio_assets user currency]))
            end
          end

          context 'when updating an existing investment_portfolio_asset' do
            let!(:investment_portfolio_asset) do
              create(:investment_portfolio_asset, investment_portfolio:, asset:)
            end

            let(:investment_portfolio_params) do
              {
                investment_portfolio_assets_attributes: [
                  {
                    id: investment_portfolio_asset.id,
                    asset_id: asset.id,
                    quantity: 1000,
                    allocation_weight: 100
                  }
                ]
              }
            end

            before { patch_call }

            it 'updates the investment_portfolio_asset' do
              investment_portfolio_asset.reload
              expect(response).to have_http_status(:ok)
              expect(investment_portfolio.reload.investment_portfolio_assets.count).to eq(1)
              expect(investment_portfolio_asset.attributes).to include(
                'asset_id' => asset.id,
                'quantity' => 1000,
                'allocation_weight' => 100,
                'investment_portfolio_id' => investment_portfolio.id
              )
              expect(response.parsed_body).to eq(investment_portfolio.as_json(include: %i[investment_portfolio_assets user currency]))
            end
          end

          context 'when removing an existing investment_portfolio_asset' do
            let!(:investment_portfolio_asset) do
              create(:investment_portfolio_asset, investment_portfolio:, asset:)
            end

            let(:investment_portfolio_params) do
              {
                investment_portfolio_assets_attributes: [
                  {
                    id: investment_portfolio_asset.id,
                    _destroy: true
                  }
                ]
              }
            end

            before { patch_call }

            it 'removes the investment_portfolio_asset' do
              expect(response).to have_http_status(:ok)
              expect(investment_portfolio.reload.investment_portfolio_assets.count).to eq(0)
              expect(InvestmentPortfolioAsset.find_by(id: investment_portfolio_asset.id)).to be_nil
              expect(response.parsed_body).to eq(investment_portfolio.as_json(include: %i[investment_portfolio_assets user currency]))
            end
          end

          context 'when updating the investment portfolio' do
            let(:investment_portfolio_params) do
              {
                name: 'My Updated Investment Portfolio',
                description: 'My updated description',
                currency_id: another_currency.id
              }
            end

            before { patch_call }

            it 'updates the investment portfolio' do
              expect(response).to have_http_status(:ok)
              expect(investment_portfolio.reload.attributes).to include(
                'name' => 'My Updated Investment Portfolio',
                'description' => 'My updated description',
                'currency_id' => another_currency.id
              )
              expect(response.parsed_body).to eq(investment_portfolio.as_json(include: %i[investment_portfolio_assets user currency]))
            end
          end
        end

        context 'when update params are invalid' do
          let(:investment_portfolio_params) { {} }

          it 'does not update the investment portfolio' do
            patch_call
            expect(response).to have_http_status(:unprocessable_entity)
            expect(response.parsed_body).to eq({ 'error' => 'param is missing or the value is empty: investment_portfolio' })
          end

          it { expect { patch_call }.not_to(change { investment_portfolio.reload.attributes }) }
        end
      end

      context 'when the investment portfolio does not belong to the user' do
        let(:another_user) { create(:user) }
        let(:investment_portfolio) { create(:investment_portfolio, user: another_user) }
        let(:patch_call) { patch :update, params: { id: investment_portfolio.id }, format: :json }

        it 'does not update the investment portfolio' do
          patch_call
          expect(response).to have_http_status(:not_found)
          expect(response.body).to eq({ error: 'InvestmentPortfolio not found' }.to_json)
        end

        it { expect { patch_call }.not_to(change { investment_portfolio.reload.attributes }) }
      end
    end

    context 'when the investment portfolio does not exist' do
      before { patch :update, params: { id: 0 }, format: :json }

      it 'returns a not found response' do
        expect(response).to have_http_status(:not_found)
        expect(response.body).to eq({ error: 'InvestmentPortfolio not found' }.to_json)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when the investment portfolio exists' do
      context 'when the investment portfolio belongs to the user' do
        let(:investment_portfolio) { create(:investment_portfolio, user:) }

        before { delete :destroy, params: { id: investment_portfolio.id }, format: :json }

        it 'destroys the investment portfolio' do
          expect(response).to have_http_status(:no_content)
          expect(response.body).to be_empty
          expect(InvestmentPortfolio.find_by(id: investment_portfolio.id)).to be_nil
        end
      end

      context 'when the investment portfolio does not belong to the user' do
        let(:another_user) { create(:user) }
        let(:investment_portfolio) { create(:investment_portfolio, user: another_user) }

        before { delete :destroy, params: { id: investment_portfolio.id }, format: :json }

        it 'does not destroy the investment portfolio' do
          expect(response).to have_http_status(:not_found)
          expect(response.body).to eq({ error: 'InvestmentPortfolio not found' }.to_json)
          expect(InvestmentPortfolio.find_by(id: investment_portfolio.id)).to be_present
        end
      end
    end

    context 'when the investment portfolio does not exist' do
      before { delete :destroy, params: { id: 0 }, format: :json }

      it 'returns a not found response' do
        expect(response).to have_http_status(:not_found)
        expect(response.body).to eq({ error: 'InvestmentPortfolio not found' }.to_json)
      end
    end
  end
end
