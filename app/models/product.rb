class Product < ApplicationRecord
  belongs_to :merchant
  has_and_belongs_to_many :categories
  has_many :order_items, dependent: :destroy
  has_many :reviews, dependent: :destroy

  validates :name, uniqueness: true, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
end
