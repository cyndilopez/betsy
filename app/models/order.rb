class Order < ApplicationRecord
  has_many :order_items, inverse_of: :order
  has_many :products, :through => :order_item

  #  validates that the attributes' values are included in a given set
  validates :status, presence: true, inclusion: { in: w% (pending paid )} #cancelled?
  validates :name, presence: true, if: :is_not_pending
  validates :email, presence: true, 
  # format: { with: /\A[^@\s]+@[^@\s]+\z/, message: "email must contain no white spaces" }, if: :is_not_pending
  validates :address, presence: true, if: :is_not_pending 
  validates :cc_num, presence: true, if: :is_not_pending 
  # format: { with: \d{16}|\d{4}[- ]\d{4}[- ]\d{4}[- ]\d{4}, message: "card information must present 16 digits"} 
  validates :cc_expiration, presence: true, if: :is_not_pending
  # format: { with: /^(0[1-9]|1[0-2])\/?([0-9]{4}|[0-9]{2})$, message: "must be in MM/YYYY" }, if: :is_not_pending 
  validates :cc_cvv, presence: true, if: :is_not_pending
  # format: { with: ^[0-9]{3}$, message: "must be 3 digits" }, if: :is_not_pending
  validates :zip_code, presence: true, if: :is_not_pending
  # format: {with: ^[0-9]{5}(?:-[0-9]{4})?$, message: "please input a valid postal code" }, if: :is_not_pending 
  # before_create set_status

  def total 
    total = 0
    self.order_items.each do |item|
      total += item.subtotal
    end
    return total
  end

end
