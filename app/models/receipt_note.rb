class ReceiptNote < ApplicationRecord
  acts_as_postable

  has_many :goods_entries, as: :document, dependent: :destroy
  has_many :incomes, inverse_of: :receipt_note
  accepts_nested_attributes_for :incomes, allow_destroy: true

  def table_rows
    incomes
  end

  def posting?
    goods_entries.size > 0
  end
end
