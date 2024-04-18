# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'csv'

# Generate partners
partner_names = [
  'Alpha Vantage',
  'HG Brasil',
]

partner_names.each do |partner_name|
  if !Partner.exists?(name: partner_name)
    Partner.create!(name: partner_name)
    puts "#{partner_name} partner created!"
  end
end

# Generate partner resources
partner_resources_attributes = [
  { 
    name: 'HG Brasil - Stock Price',
    description: 'API that retrieves brazilian asset prices with a delay between 15 minutes up to 1 hour. The endpoint example is: https://api.hgbrasil.com/finance/stock_price?key=282f20db&symbol=embr3',
    url: 'https://console.hgbrasil.com/documentation/finance',
    partner_id: Partner.find_by(name: 'HG Brasil').id
  },
  {
    name: 'Alpha Vantage - Symbol Search',
    description: 'API that retrieves asset information based on a keyword search. The endpoint example is: https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=IBM&apikey=demo',
    url: 'https://www.alphavantage.co/documentation/',
    partner_id: Partner.find_by(name: 'Alpha Vantage').id
  },
  {
    name: 'Alpha Vantage - Global Quote',
    description: 'API that retrieves asset price and reference date. The endpoint example is: https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=IBM&apikey=demo',
    url: 'https://www.alphavantage.co/documentation/',
    partner_id: Partner.find_by(name: 'Alpha Vantage').id
  },
  {
    name: 'Alpha Vantage - Currency Exchange Rate',
    description: 'API that retrieves currency exchange rate. The endpoint example is: https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency=USD&to_currency=JPY&apikey=demo',
    url: 'https://www.alphavantage.co/documentation/',
    partner_id: Partner.find_by(name: 'Alpha Vantage').id
  }
]

partner_resources_attributes.each do |partner_resource_attribute|
  if !PartnerResource.exists?(name: partner_resource_attribute[:name])
    PartnerResource.create!(partner_resource_attribute)
    puts "#{partner_resource_attribute[:name]} partner resource created!"
  end
end


physical_currency_list_csv = File.read(Rails.root.join('db', 'csv', 'physical_currency_list.csv'))
parsed_physical_currency_list_csv = CSV.parse(physical_currency_list_csv, headers: true, encoding: 'utf-8')

parsed_physical_currency_list_csv.each do |row|
  name = row['currency name']
  code = row['currency code']

  if !Currency.exists?(code: code, name: name)
    Currency.create!(name: name, code: code)
    puts "#{name}(#{code}) currency created!"
  end
end

# Generate cryptocurrencies
digital_currency_list_csv = File.read(Rails.root.join('db', 'csv', 'digital_currency_list.csv'))
parsed_digital_currency_list_csv = CSV.parse(digital_currency_list_csv, headers: true, encoding: 'utf-8')

parsed_digital_currency_list_csv.each do |row|
  name = row['currency name']
  code = row['currency code']

  if !Currency.exists?(code: code, name: name)
    Currency.create!(name: name, code: code)
    puts "#{name}(#{code})  currency created!"
  end
end
