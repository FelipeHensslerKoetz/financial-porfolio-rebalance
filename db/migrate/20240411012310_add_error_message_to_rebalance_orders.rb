class AddErrorMessageToRebalanceOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :rebalance_orders, :error_message, :string
  end
end
