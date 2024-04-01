require 'rails_helper'

RSpec.describe HgBrasil::Stocks do
  describe '#stock_price' do
    subject(:stock_price) { described_class.new.stock_price(symbol:) }

    context 'when searching for a stock price' do
      context 'wih valid symbol' do
        let(:symbol) { 'PETR4' }

        it 'returns the stock price' do
          VCR.use_cassette('stock_price/valid_symbol') do
            result = stock_price

            expect(result).to eq({ 'by' => 'symbol',
                                   'valid_key' => true,
                                   'results' =>
             { 'PETR4' =>
               { 'kind' => 'stock',
                 'symbol' => 'PETR4',
                 'name' => 'Petrobras',
                 'company_name' => 'Petroleo Brasileiro S.A. Petrobras',
                 'document' => '33.000.167/0001-01',
                 'description' =>
                 'Pesquisa. Lavra. Refinação. Processamento. Comércio E Transporte de Petróleo. de Seus Derivados. de Gás Natural E de Outros Hidrocarbonetos Fluidos. Além Das Atividades Vinculadas à Energia.',
                 'website' => 'http://www.petrobras.com.br/',
                 'sector' =>
                 'Petróleo. Gás e Biocombustíveis / Petróleo. Gás e Biocombustíveis / Exploração. Refino e Distribuição',
                 'financials' => { 'quota_count' => 0,
                                   'dividends' => { 'yield_12m' => nil,
                                                    'yield_12m_sum' => nil } },
                 'region' => 'Brazil/Sao Paulo',
                 'currency' => 'BRL',
                 'market_time' => { 'open' => '10:00', 'close' => '17:30',
                                    'timezone' => -3 },
                 'logo' =>
                 { 'small' => 'https://assets.hgbrasil.com/finance/companies/small/petrobras.png',
                   'big' => 'https://assets.hgbrasil.com/finance/companies/big/petrobras.png' },
                 'market_cap' => 493_504.0,
                 'price' => 37.36,
                 'change_percent' => 2.22,
                 'change_price' => 0.81,
                 'updated_at' => '2024-03-30 20:48:26' } },
                                   'execution_time' => 0.0,
                                   'from_cache' => false })
            expect(HttpRequestLog.count).to eq(1)
          end
        end
      end

      context 'with invalid symbol' do
        let(:symbol) { 'INVALID' }

        it 'returns an empty hash' do
          VCR.use_cassette('stock_price/invalid_symbol') do
            result = stock_price

            expect(result).to eq({ 'by' => 'symbol',
                                   'valid_key' => true,
                                   'results' =>
             { 'INVALID' =>
               { 'error' => true,
                 'message' =>
                 'Error to get Stock for #INVALID: Erro 852 - Símbolo não encontrado, por favor entre em contato conosco em console.hgbrasil.com.' } },
                                   'execution_time' => 0.0,
                                   'from_cache' => true })
            expect(HttpRequestLog.count).to eq(1)
          end
        end
      end
    end

    context 'when searching for a mutual fund price' do
      context 'with valid symbol' do
        let(:symbol) { 'HGLG11' }

        it 'returns the mutual fund price' do
          VCR.use_cassette('stock_price/valid_mutual_fund') do
            result = stock_price

            expect(result).to eq({ 'by' => 'symbol',
                                   'valid_key' => true,
                                   'results' =>
             { 'HGLG11' =>
               { 'kind' => 'fii',
                 'symbol' => 'HGLG11',
                 'name' => 'FII CSHG Log',
                 'company_name' => 'CSHG Logstica Fundo Investimento Imobiliario FII',
                 'document' => '11.728.688/0001-47',
                 'description' => 'Financeiro e Outros/Fundos/Fundos Imobiliários',
                 'website' => 'https://www.cshg.com.br/',
                 'sector' => 'Imóveis Industriais e Logísticos',
                 'financials' =>
                 { 'equity' => 5_176_423_292,
                   'quota_count' => 33_787_575,
                   'equity_per_share' => 153.205,
                   'price_to_book_ratio' => 1.103,
                   'dividends' => { 'yield_12m' => 8.047,
                                    'yield_12m_sum' => 13.6 } },
                 'region' => 'Brazil/Sao Paulo',
                 'currency' => 'BRL',
                 'market_time' => { 'open' => '10:00', 'close' => '17:30',
                                    'timezone' => -3 },
                 'logo' => nil,
                 'market_cap' => 5710.1,
                 'price' => 169.0,
                 'change_percent' => 0.6,
                 'change_price' => 1.01,
                 'updated_at' => '2024-03-30 20:48:26' } },
                                   'execution_time' => 0.0,
                                   'from_cache' => false })
            expect(HttpRequestLog.count).to eq(1)
          end
        end
      end

      context 'with invalid symbol' do
        let(:symbol) { 'INVALID' }

        it 'returns an empty hash' do
          VCR.use_cassette('stock_price/invalid_mutual_fund') do
            result = stock_price

            expect(result).to eq(
              { 'by' => 'symbol',
                'valid_key' => true,
                'results' =>
  { 'INVALID' =>
    { 'error' => true,
      'message' =>
      'Error to get Stock for #INVALID: Erro 852 - Símbolo não encontrado, por favor entre em contato conosco em console.hgbrasil.com.' } },
                'execution_time' => 0.0,
                'from_cache' => true }
            )
            expect(HttpRequestLog.count).to eq(1)
          end
        end
      end
    end

    context 'when http request fails' do
      let(:symbol) { 'PETR4' }

      context 'when Faraday::TimeoutError is raised' do
        before do
          allow_any_instance_of(Faraday::Connection).to receive(:get).and_raise(Faraday::TimeoutError)
        end

        it 'raises an AlphaVantage::TimeoutError' do
          expect(stock_price).to be_nil
          expect(HttpRequestLog.count).to eq(1)
        end
      end

      context 'when Faraday::ConnectionFailed is raised' do
        before do
          allow_any_instance_of(Faraday::Connection).to receive(:get).and_raise(Faraday::ConnectionFailed)
        end

        it 'raises an AlphaVantage::ConnectionFailedError' do
          expect(stock_price).to be_nil
          expect(HttpRequestLog.count).to eq(1)
        end
      end

      context 'when Faraday::ClientError is raised' do
        before do
          allow_any_instance_of(Faraday::Connection).to receive(:get).and_raise(Faraday::ClientError)
        end

        it 'raises an AlphaVantage::ClientError' do
          expect(stock_price).to be_nil
          expect(HttpRequestLog.count).to eq(1)
        end
      end

      context 'when Faraday::ServerError is raised' do
        before do
          allow_any_instance_of(Faraday::Connection).to receive(:get).and_raise(Faraday::ServerError)
        end

        it 'raises an AlphaVantage::ServerError' do
          expect(stock_price).to be_nil
          expect(HttpRequestLog.count).to eq(1)
        end
      end
    end
  end
end
