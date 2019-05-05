class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order

  validates :order, presence: true

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }

  def add_product_stock
    product = Product.find_by(id: self.product)
    add_product_stock = product.stock + self.quantity
    product.update(stock: add_product)
    return add_product_stock
  end

  def reduce_product_stock
    current_stock = self.product.stock - self.quantity
    return self.product.update(stock: current_stock)
  end

  def subtotal
    self.unit_price * self.quantity
  end

  private

  def unit_price
    self.product.price
  end
end
