class CreateOutcomes < ActiveRecord::Migration[5.2]
  def change
    create_table :outcomes do |t|
      t.references :item, foreign_key: true
      t.integer :quantity
      t.decimal :price
      t.references :delivery_note, foreign_key: true

      t.timestamps
    end
  end
end
