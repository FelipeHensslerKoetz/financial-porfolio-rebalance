class RemoveUnecessaryFieldsOnCurrencyParity < ActiveRecord::Migration[7.1]
  def change
    remove_column :currency_parities, :last_sync_at, :datetime
    remove_column :currency_parities, :data_origin_id, :integer
    remove_column :currency_parities, :exchange_rate, :decimal
  end
end
