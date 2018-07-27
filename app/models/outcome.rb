class Outcome < ApplicationRecord
  include Report
  belongs_to :item
  belongs_to :delivery_note

  validates :delivery_note, presence: true
  validates :quantity, numericality: { greater_than: 0,
    less_than_or_equal_to: :avialble_quantity }

  delegate :name, to: :item, prefix: true
  delegate :date, to: :delivery_note, prefix: 'out'

  private

    def avialble_quantity
      Report.available_quantity_for(item_id)
    end
end
