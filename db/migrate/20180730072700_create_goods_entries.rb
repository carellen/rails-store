class CreateGoodsEntries < ActiveRecord::Migration[5.2]
  def change
    create_table :goods_entries do |t|
      t.datetime :date_in
      t.datetime :date_out
      t.integer :quantity
      t.decimal :price
      t.references :document, polymorphic: true, index: true
      t.references :item, foreign_key: true

      t.timestamps
    end
  end
end
