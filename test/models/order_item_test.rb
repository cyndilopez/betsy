require "test_helper"

describe OrderItem do
  let(:order_item) { order_items(:one) }

  describe "validations" do
    it "is valid for product and order" do
      expect(order_item.valid?).must_equal true
    end

    it "has a product price" do
      order_item.unit_price = "10.99"
      expect(order_item.valid?).must_equal true
    end

    
    it "belongs to a product" do
      expect(order_item.product).wont_be_nil 
      expect(order_item.product).must_be_instance_of Product
    end
    
    it "belongs to an order" do
      expect(order_item.order).wont_be_nil
      expect(order_item.order).must_be_instance_of Order
    end
    
    it "has a merchant" do
      expect(order_item.merchant).wont_be_nil
      expect(order_item.merchant).must_be_instance_of Merchant
    end
    
  end
  

end
  

