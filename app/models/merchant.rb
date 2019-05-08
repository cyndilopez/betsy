class Merchant < ApplicationRecord
  has_many :products
  has_many :order_items, through: :products

  validates :username, uniqueness: true, presence: true
  validates :email, uniqueness: true, presence: true

  def self.build_from_github(auth_hash)
    merchant = Merchant.new
    merchant.username = auth_hash["info"]["nickname"]
    merchant.name = auth_hash["info"]["name"]
    merchant.email = auth_hash["info"]["email"]
    merchant.uid = auth_hash[:uid]
    merchant.provider = "github"

    return merchant
  end
  
  # def order_items
  #   products = self.products
    
  #   products.each do |product|
  #     puts product.order_items
  #   end
  # end
  
  
  def total_revenue
    total_revenue = 0
    self.order_items.each do |item|
      total_revenue += item.subtotal
    end
    return total_revenue
  end
  
end
