class Product < ApplicationRecord
  belongs_to :merchant

  validates :name, uniqueness: true, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
end
