class CreateRebalances < ActiveRecord::Migration[7.1]
  def change
    create_table :rebalances do |t|
      t.references :rebalance_order, null: false, foreign_key: true
      t.json :before_rebalance, null: false
      t.json :after_rebalance, null: false
      t.string :status, null: false
      t.boolean :reflected_to_investment_portfolio, null: false, default: false
      t.string :error_message
      t.datetime :expires_at, null: false

      t.timestamps
    end
  end
end
