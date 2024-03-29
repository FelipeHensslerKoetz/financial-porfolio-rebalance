class CreateRebalanceOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :rebalance_orders do |t|
      t.references :user, null: false, foreign_key: true
      t.references :investment_portfolio, null: false, foreign_key: true
      t.string :status, null: false
      t.string :type, null: false
      t.decimal :amount
      t.datetime :requested_at

      t.timestamps
    end
  end
end
