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

  before do
    [receipt_note, receipt_note_2, delivery_note].each do |i|
        DocumentService.new(i).posting
    end
  end

  it 'should calculate correct rest of items' do
    items = described_class.calculate_for.map(&:to_a)
    expect(items). to eq([
      [item_1.id, date_2.utc.strftime("%Y-%m-%d %T.%6L"), "12.0", 2],
      [item_2.id, date_1.utc.strftime("%Y-%m-%d %T.%6L"), "15.0", 1]
     ])
  end
end
