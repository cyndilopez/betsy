class Order < ApplicationRecord
  has_many :order_items, inverse_of: :order
  has_many :products, :through => :order_item

  validates :status, presence: true

  # before_create set_status

  def total
    total = 0
    self.order_items.each do |item|
      total += item.subtotal
    end
    return total
  end

  private

  # def set_status
  #   self.status = "pending"
  # end
end
