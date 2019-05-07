class Category < ApplicationRecord
  has_and_belongs_to_many :products
  validates :name, uniqueness: true, presence: true

  def self.filter_by_category(params)
    category = Category.find_by(id: params[:id])
    @products = category.products.select { |p| p.active }
  end
end
