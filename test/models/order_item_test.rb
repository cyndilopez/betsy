require "test_helper"

describe OrderItem do
  let(:order_item) { order_items(:one) }

  describe "validations" do
    it "is valid for product, order and quantity" do
      expect(order_item.valid?).must_equal true
    end

    it "requires an order" do
      order_item.order_id = nil
      expect(order_item.valid?).must_equal false
    end

    it "requires a product" do
      order_item.product_id = nil
      expect(order_item.valid?).must_equal false
    end

    it "requires a quantity" do
      order_item.quantity = nil
      expect(order_item.valid?).must_equal false
    end

    it "has a quantity that is an integer and greater than zero" do
      cases = ["string", 1.45, :tree, -1, -1.45]
      cases.each do |item|
        order_item.quantity = item
        expect(order_item.valid?).must_equal false
      end
    end

    it "has a product price" do
      order_item.product.price = "10.99"
      expect(order_item.valid?).must_equal true
    end
  end

  describe "relations" do
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

  describe "subtotal" do
    it "calculates a subtotal" do
      product = products(:starbursts)
      order = orders(:two)
      price = product.price
      order_item = OrderItem.new(product: product, order: order, quantity: 5)
      total = price * 5

      expect(order_item.subtotal).must_equal total
    end
  end
end
