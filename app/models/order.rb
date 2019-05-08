require "uri"

class Order < ApplicationRecord
  has_many :order_items, inverse_of: :order
  has_many :products, :through => :order_item

  #  validates that the attributes' values are included in a given set
  validates :status, presence: true, inclusion: { in: %w(pending paid) }
  validates :name, presence: true, if: :is_not_pending,
                   format: { with: /[a-zA-Z]{2,}/, message: "name must be at least 2 characters long" }
  validates :email, presence: true, if: :is_not_pending,
                    format: { with: /\A[^@\s]+@[^@\s]+\z/, message: "email must contain no white spaces" }
  validates :address, presence: true, if: :is_not_pending
  validates :cc_num, presence: true, if: :is_not_pending,
                     format: { with: /(\d{4}[- ]){4}\d{4}|\d{16}/, message: "card information must present 16 digits" }
  validates :cc_expiration, presence: true, if: :is_not_pending,
                            format: { with: /\A(0[1-9]|1[0-2])\/?([0-9]{4}|[0-9]{2})\z/, message: "must be in format MMYYYY" }
  validates :cc_cvv, presence: true, if: :is_not_pending,
                     format: { with: /\A[0-9]{3}\z/, message: "must be 3 digits" }
  validates :zip_code, presence: true, if: :is_not_pending,
                       format: { with: /\A[0-9]{5}(?:-[0-9]{4})?\z/, message: "please input a valid postal code" }

  def is_not_pending
    status == "paid"
  end

  def total
    total = 0
    self.order_items.each do |item|
      total += item.subtotal
    end
    return total
  end

  def product_update
    self.order_items.each do |order_item|
      order_item.reduce_product_stock
    end
  end
end
