require 'rails_helper'

RSpec.describe Postable do
  let(:date_1) { Time.now - 2.hour }
  let(:date_2) { Time.now - 1.hour }
  let(:date_3) { Time.now - 30.minute }
  let(:date_4) { Time.now - 15.minute }
  let(:date_5) { Time.now - 10.minute }
  let!(:item_1) { Item.create!(name: 'First item') }
  let!(:item_2) { Item.create!(name: 'Second item') }
  let!(:item_3) { Item.create!(name: 'Third item') }
  let!(:receipt_note_1) { ReceiptNote.create!(date: date_1, supplier: 'Supplier') }
  let!(:receipt_note_2) { ReceiptNote.create!(date: date_2, supplier: 'Supplier') }
  let!(:delivery_note_1) { DeliveryNote.create!(date: date_3, customer: 'Customer') }
  let!(:receipt_note_3) { ReceiptNote.create!(date: date_4, supplier: 'Supplier') }
  let!(:delivery_note_2) { DeliveryNote.create!(date: date_5, customer: 'Customer') }
  let!(:income_1) { Income.create!(item: item_1, quantity: 2, price: 10.0, receipt_note: receipt_note_1) }
  let!(:income_1_2) { Income.create!(item: item_1, quantity: 2, price: 12.0, receipt_note: receipt_note_2) }
  let!(:outcome_1) { Outcome.create!(item: item_1, quantity: 3, price: 22.0, delivery_note: delivery_note_1) }
  let!(:income_1_3) { Income.create!(item: item_1, quantity: 2, price: 14.0, receipt_note: receipt_note_3) }
  let!(:outcome_2) { Outcome.create!(item: item_1, quantity: 2, price: 25.0, delivery_note: delivery_note_2) }

  before do
    [receipt_note_1, receipt_note_2].each do |i|
      i.post
      i.reload
    end
  end

  it 'should create proper goods_entries for receipt_note' do
    entries = GoodsEntry.all.map { |e|
      [e.date_in, e.date_out,
         e.quantity, e.cost_price, e.sale_price, e.item_id] }

    expect(entries).to match_array([
      [date_1, nil, 2, 10.0, nil, item_1.id],
      [date_2, nil, 2, 12.0, nil, item_1.id]
      ])
  end

  it 'should delete old goods_entries when posting document' do
    income_1.update!(receipt_note: receipt_note_2)
    receipt_note_1.post
    receipt_note_1.reload
    entries = receipt_note_1.goods_entries

    expect(entries).to be_empty
  end

  it 'should create proper goods_entries for delivery_note' do
    [delivery_note_1, receipt_note_3, delivery_note_2].each do |i|
      i.post
      i.reload
    end

    entries = GoodsEntry.where(document_type: 'DeliveryNote').map { |e|
      [e.date_in, e.date_out,
         e.quantity, e.cost_price, e.sale_price, e.item_id] }

    expect(entries).to match_array([
      [date_1, date_3, -2, 10.0, 22.0, item_1.id],
      [date_2, date_3, -1, 12.0, 22.0, item_1.id],
      [date_2, date_5, -1, 12.0, 25.0, item_1.id],
      [date_4, date_5, -1, 14.0, 25.0, item_1.id]
      ])
  end
end
