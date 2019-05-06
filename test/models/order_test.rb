require "test_helper"

describe Order do
  let(:order) { orders(:two) }

  describe "validations" do
    it "is valid for name, status, email, cc_num, cc_cvv, cc_expiration and zip code" do
      expect(order.valid?).must_equal true
    end
  end
end
