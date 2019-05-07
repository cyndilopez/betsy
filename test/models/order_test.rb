require "test_helper"

describe Order do
  let(:order) { orders(:two) }
  let(:order_noname) { orders(:no_name) }

  describe "validations" do
    it "is valid for name, status, email, cc_num, cc_cvv, cc_expiration and zip code" do
      expect(order.valid?).must_equal true
    end

    it "requires a name" do
      order = Order.new()
    end

    it "is invalid without a name" do
      order.name = nil
      expect(order.valid?).must_equal false
    end
  end
end
