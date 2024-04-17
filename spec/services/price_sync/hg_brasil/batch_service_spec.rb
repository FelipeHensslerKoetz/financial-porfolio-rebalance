require 'rails_helper'

RSpec.describe PriceSync::HgBrasil::BatchService, type: :service do
  subject(:batch_service) { described_class.new(asset_symbols:) }

  let!(:petr4) { create(:asset, code: 'PETR4') }
  let!(:wizc3) { create(:asset, code: 'WIZC3') }
  let!(:data_origin) { create(:data_origin, name: 'HG Brasil') }
  let!(:petr4_price) do
    create(:asset_price,
           asset: petr4,
           code: 'PETR4',
           status: 'outdated',
           data_origin:)
  end

  let!(:wizc3_price) do
    create(:asset_price,
           asset: wizc3,
           code: 'WIZC3',
           status: 'outdated',
           data_origin:)
  end

  let(:asset_symbols) { "#{petr4.code},#{wizc3.code}" }

  describe '#call' do
    context 'when batch update is successful' do
      let(:hg_brasil_response) do
        [
          {
            code: 'PETR4',
            kind: 'stock',
            business_name: 'Petróleo Brasileiro S.A. - Petrobras',
            name: 'Petróleo Brasileiro S.A. - Petrobras',
            price: 25.0,
            reference_date: Time.zone.parse('2023-04-17'),
            currency: 'BRL',
            custom: false
          },
          {
            code: 'WIZC3',
            kind: 'stock',
            business_name: 'Wiz Soluções e Corretagem de Seguros S.A.',
            name: 'Wiz Soluções e Corretagem de Seguros S.A.',
            price: 5.0,
            reference_date: Time.zone.parse('2023-04-17'),
            currency: 'BRL',
            custom: false
          }
        ]
      end

      before do
        allow(HgBrasil::Stocks).to receive(:asset_details_batch).with(symbols: asset_symbols).and_return(hg_brasil_response)
        batch_service.call
      end

      it 'updates assets to success status' do
        expect(petr4_price.reload.status).to eq('up_to_date')
        expect(petr4_price.reload.price).to eq(hg_brasil_response[0][:price])
        expect(petr4_price.reference_date).to eq(hg_brasil_response[0][:reference_date])
        expect(wizc3_price.reload.status).to eq('up_to_date')
        expect(wizc3_price.reload.price).to eq(hg_brasil_response[1][:price])
        expect(wizc3_price.reference_date).to eq(hg_brasil_response[1][:reference_date])
        expect(HgBrasil::Stocks).to have_received(:asset_details_batch).with(symbols: asset_symbols).once
      end
    end

    context 'when batch update fails' do
      before do
        allow(HgBrasil::Stocks).to receive(:asset_details_batch).with(symbols: asset_symbols).and_raise(StandardError)
        batch_service.call
      end

      it 'update assets to error status' do
        expect(petr4_price.reload.status).to eq('error')
        expect(wizc3_price.reload.status).to eq('error')
      end
    end
  end
end
