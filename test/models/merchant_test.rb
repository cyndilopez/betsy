require "test_helper"

describe Merchant do
  let(:merchant) { Merchant.new }
  let(:email) { "merchant@here.com" }
  let(:username) { "new_merchant101" }
  let(:valid_merchant) { merchants(:jenkins) }

  describe "validations" do
    it "is valid for email and username restrictions" do
      expect(valid_merchant.valid?).must_equal true
    end

    it "requires a username" do
      merchant.email = email
      expect(merchant.valid?).must_equal false
      expect(merchant.errors).must_include "username"
    end

    it "requires the username to be unique" do
      merchant_dup_username = valid_merchant.username
      merchant_dup = Merchant.new(username: merchant_dup_username, email: email)
      expect(merchant_dup.valid?).must_equal false
      expect(merchant_dup.errors).must_include "username"
    end

    it "requires an email" do
      merchant.username = username
      expect(merchant.valid?).must_equal false
      expect(merchant.errors).must_include "email"
    end

    it "requires a unique email" do
      merchant_dup_email = valid_merchant.email
      merchant_dup = Merchant.new(username: username, email: merchant_dup_email)
      expect(merchant_dup.valid?).must_equal false
      expect(merchant_dup.errors).must_include "email"
    end
  end

  describe "relations" do
    it "has many products" do
      merchant = merchants(:bob)
      expect(merchant.products.length).must_equal 2
    end

    it "has many order items" do
      merchant = merchants(:bob)
      expect(merchant.order_items.first).must_be_instance_of OrderItem
    end
  end

  describe "total revenue method" do
    it "calculates the merchant's total revenue" do
      merchant = merchants(:bob)
      order_items = merchant.order_items
      costs = []
      order_items.each do |item|
        costs << item.subtotal
      end

      total = costs.sum

      expect(merchant.total_revenue).must_be_kind_of Float
      expect(merchant.total_revenue).must_be_close_to total
    end

    it "updates the merchant's total revenue" do
      merchant = merchants(:bob)
      total_revenue = merchant.total_revenue
      order_item = merchant.order_items.first
      quantity = order_item.quantity + 2
      product = order_item.product
      order = order_item.order

      order_item_data = {
        order_item: {
          quantity: quantity,
          order_id: order.id,
          product_id: product.id,
        },
      }

      updated_revenue = total_revenue + (product.price) * 2
      order_item.update!(order_item_data[:order_item])
      merchant.reload
      order_item.reload
      expect(merchant.total_revenue).must_equal updated_revenue
    end

    it "updates total_revenue if the order item is removed" do
      merchant = merchants(:bob)
      initial_total_revenue = merchant.total_revenue
      order_item_to_delete = merchant.order_items.first
      price_order_item_to_delete = order_item_to_delete.product.price * order_item_to_delete.quantity
      order_item_to_delete.destroy
      merchant.reload
      after_total_revenue = merchant.total_revenue
      expect(after_total_revenue).must_be_close_to initial_total_revenue - price_order_item_to_delete
    end
  end

  describe "filter_by_merchant" do
    it "finds the products associated with a merchant" do
      merchant = merchants(:bob)
      merchant_data = {
        id: merchant.id,
      }
      products = Merchant.filter_by_merchant(merchant_data)
      number_of_active_products = merchant.products.where(active: true).count
      expect(products.length).must_equal number_of_active_products
    end
  end
  
  describe "helper methods" do
    it "gets a list of pending order items" do
      merchant = merchants(:bob)
      merchant2 = merchants(:jenkins)
      expect(merchant.pending_order_items.count).must_equal 1
      
      order_item = merchant.pending_order_items.first
      expect(order_item.order.status).must_equal "pending"
      expect(merchant2.pending_order_items.count).must_equal 0
    end
    
    it "gets a list of paid order items" do
      product = products(:cupcakes)
      order_item = 
      order = orders(:two)
      
      order_item = order.order_items.first
      puts order_item
      merchant = order_item.product.merchant
      puts merchant
      expect(merchant.paid_order_items.count).must_equal 1
      
      order_item = merchant.paid_order_items.first
      expect(order_item.order.status).must_equal "paid"
    end
  end
end
