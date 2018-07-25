class CreateReceiptNotes < ActiveRecord::Migration[5.2]
  def change
    create_table :receipt_notes do |t|
      t.string :supplier
      t.datetime :date

      t.timestamps
    end
  end
end
