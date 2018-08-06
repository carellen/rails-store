require 'rails_helper'

RSpec.describe ReportService do
  let(:date_1) { Time.now - 2.hour }
  let(:date_2) { Time.now - 1.hour }
  let(:date_3) { Time.now - 30.minute }
  let(:date_4) { Time.now - 10.minute }
  let!(:item_1) { Item.create!(name: 'First item') }
  let!(:item_2) { Item.create!(name: 'Second item') }
  let!(:item_3) { Item.create!(name: 'Third item') }
  let!(:receipt_note) { ReceiptNote.create!(date: date_1, supplier: 'Supplier') }
  let!(:receipt_note_2) { ReceiptNote.create!(date: date_2, supplier: 'Supplier') }
  let!(:delivery_note) { DeliveryNote.create!(date: date_3, customer: 'Customer') }
  let!(:income_1) { Income.create!(item: item_1, quantity: 2, price: 10.0, receipt_note: receipt_note) }
  let!(:income_1_2) { Income.create!(item: item_1, quantity: 3, price: 12.0, receipt_note: receipt_note_2) }
  let!(:income_2) { Income.create!(item: item_2, quantity: 2, price: 15.0, receipt_note: receipt_note) }
  let!(:income_3) { Income.create!(item: item_3, quantity: 3, price: 18.0, receipt_note: receipt_note) }
  let!(:outcome_1) { Outcome.create!(item: item_1, quantity: 3, price: 22.0, delivery_note: delivery_note) }
  let!(:outcome_2) { Outcome.create!(item: item_2, quantity: 1, price: 25.0, delivery_note: delivery_note) }
  let!(:outcome_3) { Outcome.create!(item: item_3, quantity: 3, price: 28.0, delivery_note: delivery_note) }
  let!(:delivery_note_2) { DeliveryNote.create!(date: date_4, customer: 'Customer') }
  let!(:outcome_4) { Outcome.create!(item: item_1, quantity: 1, price: 30.0, delivery_note: delivery_note_2) }
  let!(:outcome_5) { Outcome.create!(item: item_2, quantity: 1, price: 40.0, delivery_note: delivery_note_2) }
  before do
    [receipt_note, receipt_note_2, delivery_note].each(&:post)
  end

  it 'should calculate correct rest of items' do
    items = described_class.items_in_store.map(&:to_a)
    expect(items). to eq([
      [item_1.id, date_2, '12.0', 2],
      [item_2.id, date_1, '15.0', 1]
     ])
  end

  it 'should calculate correct sale data' do
    items = described_class.sold_items(date_1.utc, date_4.utc + 1.minute).map(&:to_a)
    expect(items). to eq([
      [item_1.id, 3, 32.0, 66.0, 34.0],
      [item_2.id, 1, 15.0, 25.0, 10.0],
      [item_3.id, 3, 54.0, 84.0, 30.0]
     ])
     delivery_note_2.post
     items = described_class.sold_items(date_1.utc, date_4.utc + 1.minute).map(&:to_a)
     expect(items). to eq([
       [item_1.id, 4, 44.0, 96.0, 52.0],
       [item_2.id, 2, 30.0, 65.0, 35.0],
       [item_3.id, 3, 54.0, 84.0, 30.0]
      ])
  end
end
