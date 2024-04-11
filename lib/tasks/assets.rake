require 'csv'

namespace :assets do
  desc 'Discover new assets by keywords'
  task discovery: :environment do
    puts 'Scheduling assetss search...'

    brazilian_stock_list_csv = File.read(Rails.root.join('db/csv/brazilian_assets.csv'))
    parsed_brazilian_stock_list_csv = CSV.parse(brazilian_stock_list_csv, headers: true, encoding: 'utf-8')

    brazilian_asset_codes = parsed_brazilian_stock_list_csv.map { |row| row['Ticker'] } - Asset.all.pluck(:code)

    request_delay_in_seconds = 10

    brazilian_asset_codes.each_with_index do |brazilian_asset_code, index|
      search_uuid = AssetDiscoveryJob.perform_in((request_delay_in_seconds * index).seconds, brazilian_asset_code)
      puts "Scheduling search for #{brazilian_asset_code} - #{search_uuid}"
    end

    puts 'All assets\' searches scheduled!'
  end
end
