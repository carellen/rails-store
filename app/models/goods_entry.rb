class GoodsEntry < ApplicationRecord
  belongs_to :item
  belongs_to :document, polymorphic: true

end
