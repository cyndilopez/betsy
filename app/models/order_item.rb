class OrderItem < ApplicationRecord
  belongs_to :product
  belongs_to :order
  skip_before_action :require_login

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
