class Merchant < ApplicationRecord
  has_many :products

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
end
