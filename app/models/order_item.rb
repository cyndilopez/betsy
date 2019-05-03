class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order
  
  validates :order, presence: true

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  
 
  def unit_price
    self.product.price
  end
  
  
end
