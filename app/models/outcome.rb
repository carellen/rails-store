class Outcome < ApplicationRecord
  include Report
  belongs_to :item
  belongs_to :delivery_note

  validates :delivery_note, presence: true
  validates :quantity, numericality: { greater_than: 0, less_than_or_equal_to: :available_quantity }

  delegate :name, to: :item, prefix: true
  delegate :date, to: :delivery_note, prefix: 'out'

  private

    def available_quantity
      items = Report.calculate_for(DateTime.now).reduce({}) do |h,item|
        h.merge!({ item.name => item.quantity }) do |k, old_val, new_val|
          old_val + new_val
        end
      end
      items[item_name]
    end
end
