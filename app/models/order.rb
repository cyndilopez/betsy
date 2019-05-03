class Order < ApplicationRecord
  has_many :order_items
  
  validates_associated :order_items
  validates :status, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
