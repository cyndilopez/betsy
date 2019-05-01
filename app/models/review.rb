class Review < ApplicationRecord
  belongs_to :product

  validates :rating, numericality: { only_integer: true }, length: { in: 1..5 }
end
