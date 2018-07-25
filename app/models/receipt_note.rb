class ReceiptNote < ApplicationRecord
  has_many :incomes, inverse_of: :receipt_note
  accepts_nested_attributes_for :incomes, allow_destroy: true
end
