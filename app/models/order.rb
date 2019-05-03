class Order < ApplicationRecord
  has_many :order_items, inverse_of: :order
  
  validates_associated :order_items
  validates :status, presence: true
  validates :boolean_field_name, inclusion: { in: [true, false] }
end
