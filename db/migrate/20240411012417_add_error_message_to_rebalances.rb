class AddErrorMessageToRebalances < ActiveRecord::Migration[7.1]
  def change
    add_column :rebalances, :error_message, :string
  end
end
