require 'rails_helper'

RSpec.describe Assets::Discovery::HgBrasil do
  subject(:hg_brasil_asset_discovery) { described_class.call(symbol:) }

  context 'when symbols exists' do
    let(:symbol) { 'PETR4' }

    it 'returns asset attributes' do
      VCR.use_cassette('hg_brasil/asset_discovery_success') do
        expect(hg_brasil_asset_discovery).to eq(
          [
            {
              code: 'PETR4',
              kind: 'stock',
              name: 'Petroleo Brasileiro S.A. Petrobras',
              business_name: 'Petrobras',
              document: '33.000.167/0001-01',
              description: 'Pesquisa. Lavra. Refinação. Processamento. Comércio E Transporte de Petróleo. de Seus Derivados. de Gás Natural E de Outros Hidrocarbonetos Fluidos. Além Das Atividades Vinculadas à Energia.',
              website: 'http://www.petrobras.com.br/',
              sector: 'Petróleo. Gás e Biocombustíveis / Petróleo. Gás e Biocombustíveis / Exploração. Refino e Distribuição',
              region: 'Brazil/Sao Paulo',
              market_time: { 'open' => '10:00', 'close' => '17:30',
                             'timezone' => -3 },
              logo: {
                'small' => 'https://assets.hgbrasil.com/finance/companies/small/petrobras.png',
                'big' => 'https://assets.hgbrasil.com/finance/companies/big/petrobras.png'
              }
            }
          ]
        )
      end
    end
  end

  context 'when symbols does not exists' do
    let(:symbol) { 'INVALID' }

    it 'returns empty array' do
      VCR.use_cassette('hg_brasil/asset_discovery_not_found') do
        expect(hg_brasil_asset_discovery).to eq([])
      end
    end
  end

  context 'when request fails' do
    let(:symbol) { 'PETR4' }

    before do
      allow_any_instance_of(Faraday::Connection).to receive(:get).and_raise(Faraday::TimeoutError)
    end

    it 'returns empty array' do
      VCR.use_cassette('hg_brasil/asset_discovery_error') do
        expect(hg_brasil_asset_discovery).to eq([])
      end
    end
  end
end
