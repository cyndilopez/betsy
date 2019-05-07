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

  private

  def unit_price
    self.product.price
  end
end
