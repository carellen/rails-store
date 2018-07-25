class Outcome < ApplicationRecord
  belongs_to :item
  belongs_to :delivery_note
end
