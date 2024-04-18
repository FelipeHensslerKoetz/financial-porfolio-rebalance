class CreateInvestmentPortfolioAssets < ActiveRecord::Migration[7.1]
  def change
    create_table :investment_portfolio_assets do |t|
      t.references :asset, null: false, foreign_key: true
      t.references :investment_portfolio, null: false, foreign_key: true
      t.decimal :allocation_weight, precision: 10, scale: 2, null: false
      t.decimal :quantity, precision: 10, scale: 2, null: false
      t.decimal :maximum_accepted_deviation_percentage, precision: 10, scale: 2, null: true

      t.timestamps
    end
  end
end
