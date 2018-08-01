class AddSalePriceToGoodsEntries < ActiveRecord::Migration[5.2]
  def change
    add_column :goods_entries, :sale_price, :decimal
  end
end
