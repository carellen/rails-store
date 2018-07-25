class Outcome < ApplicationRecord
  belongs_to :item
  belongs_to :delivery_note

  validates :delivery_note, presence: true

  delegate :name, to: :item, prefix: true
  delegate :date, to: :delivery_note, prefix: 'out'
end
