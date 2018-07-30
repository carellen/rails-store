require 'rails_helper'

RSpec.describe ReportService do
  let(:date_1) { DateTime.now - 2.hour }
  let(:date_2) { DateTime.now - 1.hour }
  let(:date_3) { DateTime.now - 30.minute }
  let!(:item_1) { Item.create!(name: 'First item')}
  let!(:item_2) { Item.create!(name: 'Second item')}
  let!(:item_3) { Item.create!(name: 'Third item')}
  let!(:receipt_note) { ReceiptNote.create!(date: date_1, supplier: 'Supplier')}
  let!(:receipt_note_2) { ReceiptNote.create!(date: date_2, supplier: 'Supplier')}
  let!(:delivery_note) { DeliveryNote.create!(date: date_3, customer: 'Customer')}
  let!(:income_1) { Income.create!(item: item_1, quantity: 2, price: 12.0, receipt_note: receipt_note)}
  let!(:income_1_2) { Income.create!(item: item_1, quantity: 3, price: 12.0, receipt_note: receipt_note_2)}
  let!(:income_2) { Income.create!(item: item_2, quantity: 2, price: 15.0, receipt_note: receipt_note)}
  let!(:income_3) { Income.create!(item: item_3, quantity: 3, price: 18.0, receipt_note: receipt_note)}
  let!(:outcome_1) { Outcome.create!(item: item_1, quantity: 3, price: 22.0, delivery_note: delivery_note)}
  let!(:outcome_2) { Outcome.create!(item: item_2, quantity: 1, price: 25.0, delivery_note: delivery_note)}
  let!(:outcome_3) { Outcome.create!(item: item_3, quantity: 3, price: 28.0, delivery_note: delivery_note)}

  it 'should calculate correct rest of items' do
    items = described_class.calculate_for(DateTime.now)
    items_quantity = items.map { |item| [item.name, item.quantity] }
    expect(items_quantity). to eq(
      [["First item", 2], ["Second item", 1]]
    )
  end

  it 'should remove items as FIFO' do
    items = described_class.calculate_for(DateTime.now)
    items_dates = items.map { |item| [item.quantity, item.date] }
    expect(items_dates). to eq(
      [[2, date_2], [1, date_1]]
    )
  end
end
