class Item < ApplicationRecord
  has_many :income
  has_many :outcome
  has_many :goods_entries

  validates :name, uniqueness: true
end
