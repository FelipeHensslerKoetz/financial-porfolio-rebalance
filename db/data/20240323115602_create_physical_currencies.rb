# frozen_string_literal: true
require 'csv'

class CreatePhysicalCurrencies < ActiveRecord::Migration[7.1]
  def up
    csv_text = File.read(Rails.root.join('db', 'csv', 'physical_currency_list.csv'))
    csv = CSV.parse(csv_text, headers: true, encoding: 'utf-8')

    csv.each do |row|
      name = row['currency name']
      code = row['currency code']

      Currency.create!(name: name, code: code)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
