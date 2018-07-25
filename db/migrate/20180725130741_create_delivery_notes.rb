class CreateDeliveryNotes < ActiveRecord::Migration[5.2]
  def change
    create_table :delivery_notes do |t|
      t.string :customer
      t.datetime :date

      t.timestamps
    end
  end
end
