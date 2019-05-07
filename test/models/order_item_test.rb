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
  end
end
