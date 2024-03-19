class CreateInvestmentPortfolios < ActiveRecord::Migration[7.1]
  def change
    create_table :investment_portfolios do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.string :description
      t.string :image_path
      t.references :currency, null: false, foreign_key: true

      t.timestamps
    end
  end
end
