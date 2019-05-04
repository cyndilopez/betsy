class Category < ApplicationRecord
  # belongs_to :merchant
  has_and_belongs_to_many :products
end
