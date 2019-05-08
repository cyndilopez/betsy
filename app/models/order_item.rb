class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order

  validates :order, presence: true

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  def subtotal
    self.unit_price * self.quantity
  end

  def reduce_product_stock
    current_stock = self.product.stock - self.quantity
    return self.product.update(stock: current_stock)
  end

  def subtotal
    self.unit_price * self.quantity
  end
  
  def unit_price
    self.product.price
  end
  
  def merchant
    product = Product.find(self.product_id)
    return Merchant.find(product.merchant_id)
  end
  
  private


end
