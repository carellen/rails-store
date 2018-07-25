class DeliveryNote < ApplicationRecord
  has_many :outcomes
  accepts_nested_attributes_for :outcomes, allow_destroy: true
end
