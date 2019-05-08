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

  describe "reduce product stock" do
    it "updates product stock" do
      product = products(:jelly_beans)
      initial_stock = product.stock
      order_item = order_items(:two)
      order_item.reduce_product_stock

      product.reload

      expect(product.stock).must_equal initial_stock - order_item.quantity
    end
  end

  describe "unit price" do
    it "show a single unit product price" do
      expect(order_item.unit_price).must_be_close_to 15.74
    end
  end
end
