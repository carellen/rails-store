class DeliveryNote < ApplicationRecord
  include DocumentService
  
  has_many :goods_entries, as: :document, dependent: :destroy
  has_many :outcomes
  accepts_nested_attributes_for :outcomes, allow_destroy: true

  def table_rows
    outcomes
  end

  def posting?
    goods_entries.size > 0
  end
end
