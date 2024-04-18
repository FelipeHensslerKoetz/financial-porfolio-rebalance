require 'rails_helper'

RSpec.describe Assets::Price do
  subject(:price) { described_class.new(asset:, output_currency:) }

  let(:petr4_asset) do
    create(:asset,
           code: 'PETR4',
           name: 'Petrobras',
           business_name: 'Petróleo Brasileiro S.A. - Petrobras')
  end
  let(:brl_currency) { create(:currency, :brl) }
  let(:usd_currency) { create(:currency, :usd) }
  let(:btc_currency) { create(:currency, :btc) }

  context 'when asset price can be calculated' do
    let(:asset) { petr4_asset }
    let(:output_currency) { usd_currency }

    before do
      create(:asset_price,
             :with_hg_brasil_stock_price_partner_resource,
             asset:,
             currency: brl_currency,
             price: 38.94,
             status: :updated)

      currency_parity = create(:currency_parity,
                               currency_from: usd_currency,
                               currency_to: brl_currency)

      create(:currency_parity_exchange_rate,
             :with_hg_brasil_stock_price_partner_resource,
             currency_parity:,
             exchange_rate: 5.12)
    end

    it 'returns the asset price in the target currency' do
      response = price.call
      expect(response).to be_a(BigDecimal)
      expect(response.truncate(2)).to eq(7.6.to_d)
      expect(response * 5.12.to_d).to eq(38.94.to_d)
    end
  end

  context 'when asset price cannot be calculated' do
    context 'when asset param is invalid' do
      let(:asset) { nil }
      let(:output_currency) { usd_currency }

      it { expect { price.call }.to raise_error(ArgumentError) }
    end

    context 'when output_currency param is invalid' do
      let(:asset) { create(:asset) }
      let(:output_currency) { nil }

      it { expect { price.call }.to raise_error(ArgumentError) }
    end

    context 'when all asset prices are outdated or does not exists' do
      let(:asset) { petr4_asset }
      let(:output_currency) { usd_currency }

      it { expect { price.call }.to raise_error(OutdatedAssetPriceError) }
    end

    context 'when there are no currency parities' do
      let(:asset) { petr4_asset }
      let(:output_currency) { btc_currency }
      let!(:asset_price) do
        create(:asset_price,
               :with_hg_brasil_stock_price_partner_resource,
               asset:,
               currency: brl_currency,
               status: :updated)
      end

      it { expect { price.call }.to raise_error(MissingCurrencyParityError) }
    end

    context 'when there are outdated only currency parities' do
      let(:asset) { petr4_asset }
      let(:output_currency) { btc_currency }
      let!(:asset_price) do
        create(:asset_price,
               :with_hg_brasil_stock_price_partner_resource,
               asset:,
               currency: brl_currency,
               status: :updated)
      end

      let!(:currency_parity) do
        create(:currency_parity,
               currency_from: btc_currency,
               currency_to: brl_currency)
      end

      let!(:currency_parity_exchange_rate) do
        create(:currency_parity_exchange_rate, :with_hg_brasil_stock_price_partner_resource, :outdated, currency_parity:)
      end

      it { expect { price.call }.to raise_error(OutdatedCurrencyParityError) }
    end
  end
end
