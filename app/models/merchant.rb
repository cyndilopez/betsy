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

  def self.filter_by_merchant(params)
    merchant = Merchant.find_by(id: params[:id])
    @products = merchant.products.select { |p| p.active }
  end

  
  def total_revenue
    total_revenue = 0
    self.order_items.each do |item|
      total_revenue += item.subtotal
    end
    return total_revenue
  end
  
  # def total_revenue_by_status(status)
  #   total = 0
  #   orders = self.orders.where(status: status)
  #     orders.each do |order|
  #       order.order_items. 
  #    end  
  #   # revenue += order.order_items.where(merchant_id: merchant.id).subtotal
  # end
  
  def paid_order_items
    paid = []
    revenue = 0
    self.order_items.each do |order_item|
      if order_item.order.status == "paid"
        order_item.unit_price += revenue
        paid << order_item
      end
    end
    return revenue
  end
  
  def pending_order_items
    revenue = 0
    pending = []
    self.order_items.each do |order_item|
      if order_item.order.status == "pending"
        order_item.unit_price += revenue
        pending << order_item
      end
    end
    return revenue
  end
  
  # def self.orders
  #   self.products.map do |product|
  #     product.order_items.each do |order_item|
  #       order_item.orders
  #     end
  #   end
  # end
  
end
