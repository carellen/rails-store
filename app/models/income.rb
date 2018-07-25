class Income < ApplicationRecord
  belongs_to :item
  belongs_to :receipt_note

  validates :receipt_note, presence: true

  delegate :name, to: :item, prefix: true
  delegate :date, to: :receipt_note, prefix: 'in'
end
