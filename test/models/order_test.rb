require "test_helper"

describe Order do
  let(:order) { orders(:two) }

  describe "validations" do
    it "is valid for name, status, email, cc_num, cc_cvv, cc_expiration and zip code" do
      expect(order.valid?).must_equal true
    end

    it "is invalid without a name" do
      order.name = nil
      expect(order.valid?).must_equal false
    end

    it "is invalid without an email" do
      order.email = nil
      expect(order.valid?).must_equal false
    end

    it "is invalid without an address" do
      order.address = nil
      expect(order.valid?).must_equal false
    end

    it "is invalid without a cc_num" do
      order.cc_num = nil
      expect(order.valid?).must_equal false
    end

    it "is invalid without a cc_cvv" do
      order.cc_cvv = nil
      expect(order.valid?).must_equal false
    end

    it "is invalid without a cc_expiration" do
      order.cc_expiration = nil
      expect(order.valid?).must_equal false
    end

    it "is invalid without a cc_num" do
      order.cc_num = nil
      expect(order.valid?).must_equal false
    end

    it "is invalid without a zip_code" do
      order.zip_code = nil
      expect(order.valid?).must_equal false
    end

    it "is invalid without a valid status" do
      order.status = "cancelled"
      expect(order.valid?).must_equal false
    end
  end
end
