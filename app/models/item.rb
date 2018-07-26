class Item < ApplicationRecord
  has_many :income
  has_many :outcome

  validates :name, uniqueness: true
end
