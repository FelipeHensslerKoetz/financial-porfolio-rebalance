FactoryBot.define do
  factory :partner_resource do
    trait :hg_brasil_stock_price do
      name { 'HG Brasil - Stock Price' }
      description { 'API that retrieves brazilian asset prices with a delay between 15 minutes up to 1 hour. The endpoint example is: https://api.hgbrasil.com/finance/stock_price?key=282f20db&symbol=embr3' }
      url { 'https://console.hgbrasil.com/documentation/finance' }
      partner do
        create(:partner, :hg_brasil) unless Partner.exists?(name: 'HG Brasil')
        Partner.find_by(name: 'HG Brasil')
      end
    end

    trait :alpha_vantage_symbol_search do
      name { 'Alpha Vantage - Symbol Search' }
      description { 'API that retrieves asset information based on a keyword search. The endpoint example is: https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=IBM&apikey=demo' }
      url { 'https://www.alphavantage.co/documentation/' }
      partner do
        create(:partner, :alpha_vantage) unless Partner.exists?(name: 'Alpha Vantage')
        Partner.find_by(name: 'Alpha Vantage')
      end
    end

    trait :alpha_vantage_global_quote do
      name { 'Alpha Vantage - Global Quote' }
      description { 'API that retrieves asset price and reference date. The endpoint example is: https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=IBM&apikey=demo' }
      url { 'https://www.alphavantage.co/documentation/' }
      partner do
        create(:partner, :alpha_vantage) unless Partner.exists?(name: 'Alpha Vantage')
        Partner.find_by(name: 'Alpha Vantage')
      end
    end

    trait :alpha_vantage_currency_exchange_rate do
      name { 'Alpha Vantage - Currency Exchange Rate' }
      description { 'API that retrieves currency exchange rate. The endpoint example is: https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency=USD&to_currency=JPY&apikey=demo' }
      url { 'https://www.alphavantage.co/documentation/' }
      partner do
        create(:partner, :alpha_vantage) unless Partner.exists?(name: 'Alpha Vantage')
        Partner.find_by(name: 'Alpha Vantage')
      end
    end
  end
end
