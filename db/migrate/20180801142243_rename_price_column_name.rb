class RenamePriceColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :goods_entries, :price, :cost_price
  end
end
