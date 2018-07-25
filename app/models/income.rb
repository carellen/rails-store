class Income < ApplicationRecord
  belongs_to :item
  belongs_to :receipt_note

  validates :receipt_note, presence: true
end
