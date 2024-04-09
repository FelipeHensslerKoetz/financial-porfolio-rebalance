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

# Create  application data origins 
puts 'Generating data origins...'

data_origins = [
  'Alpha Vantage',
  'HG Brasil',
]

data_origins.each do |data_origin|
  if !DataOrigin.exists?(name: data_origin)
    DataOrigin.create!(name: data_origin)
    puts "#{data_origin} created!"
  else
    puts "#{data_origin} already exists, skipping..."
  end
end

puts 'Data origins generated!'

# Generate currencies
puts 'Generating currencies...'

physical_currency_list_csv = File.read(Rails.root.join('db', 'csv', 'physical_currency_list.csv'))
parsed_physical_currency_list_csv = CSV.parse(physical_currency_list_csv, headers: true, encoding: 'utf-8')

parsed_physical_currency_list_csv.each do |row|
  name = row['currency name']
  code = row['currency code']

  if !Currency.exists?(code: code, name: name)
    Currency.create!(name: name, code: code)
    puts "#{name}(#{code}) created!"
  end
end

puts 'Currencies generated!'

# Generate cryptocurrencies
puts 'Generating cryptocurrencies...'

digital_currency_list_csv = File.read(Rails.root.join('db', 'csv', 'digital_currency_list.csv'))
parsed_digital_currency_list_csv = CSV.parse(digital_currency_list_csv, headers: true, encoding: 'utf-8')

parsed_digital_currency_list_csv.each do |row|
  name = row['currency name']
  code = row['currency code']

  if !Currency.exists?(code: code, name: name)
    Currency.create!(name: name, code: code)
    puts "#{name}(#{code}) created!"
  end
end

puts 'Cryptocurrencies generated!'

# Generate brazilian stocks

puts 'Generating brazilian stocks...'

brazilian_stock_list_csv = File.read(Rails.root.join('db', 'csv', 'brazilian_stocks.csv'))
parsed_brazilian_stock_list_csv = CSV.parse(brazilian_stock_list_csv, headers: true, encoding: 'utf-8')

parsed_brazilian_stock_list_csv.each do |row|
  code = row['Ticker']

  if !Asset.exists?(code: code)
    puts '---------------------------'
    puts "Searching for #{code}"
    news_assets = Assets::Discovery::Global.new(keywords: code).call
    news_assets.each do |asset|
      puts "New asset created: #{asset.name}(#{asset.code})"
    end
  end
end

puts 'Brazilian stocks generated!'

puts 'Generating brazilian mutual funds...'

brazilian_mutual_fund_list_csv = File.read(Rails.root.join('db', 'csv', 'brazilian_mutual_funds.csv'))
parsed_brazilian_mutual_fund_list_csv = CSV.parse(brazilian_mutual_fund_list_csv, headers: true, encoding: 'utf-8')

parsed_brazilian_mutual_fund_list_csv.each do |row|
  code = row['Ticker']

  if !Asset.exists?(code: code)
    puts '---------------------------'
    puts "Searching for #{code}"
    news_assets = Assets::Discovery::Global.new(keywords: code).call
    news_assets.each do |asset|
      puts "New asset created: #{asset.name}(#{asset.code})"
    end
  end
end

puts 'Brazilian mutual funds generated!'