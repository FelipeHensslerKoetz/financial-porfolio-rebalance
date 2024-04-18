class CreateRebalances < ActiveRecord::Migration[7.1]
  def change
    create_table :rebalances do |t|
      t.references :rebalance_order, null: false, foreign_key: true
      t.json :state_before_rebalance, null: false
      t.json :state_after_rebalance, null: false
      t.json :calculation_details, null: false
      t.json :recommended_actions, null: false
      t.string :status, null: false
      t.string :error_message

      t.timestamps
    end
  end
end
