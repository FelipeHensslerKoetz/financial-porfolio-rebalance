class AddStatusToCurrencyParityTracker < ActiveRecord::Migration[7.1]
  def change
    add_column :currency_parity_trackers, :status, :string, null: false
  end
end
