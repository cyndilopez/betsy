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

    it "is invalid without an email on correct format" do
      order.email = "jansenada.edu"
      expect(order.valid?).must_equal false
    end

    it "is valid with an email in the right format" do
      order.email = "customer@email.com"
      expect(order.valid?).must_equal true
    end

    it "is invalid without an address" do
      order.address = nil
      expect(order.valid?).must_equal false
    end

    it "is invalid without a cc_num" do
      order.cc_num = nil
      expect(order.valid?).must_equal false
    end

    it "is invalid without a cc_num in the right format" do
      order.cc_num = "ASj34JKJ@#$45"
      expect(order.valid?).must_equal false
    end

    it "is invalid without a cc_num in the right format" do
      order.cc_num = "1111222233334444"
      expect(order.valid?).must_equal true
    end

    it "is invalid without a cc_cvv" do
      order.cc_cvv = nil
      expect(order.valid?).must_equal false
    end

    it "is invalid for an incorrect input of cc_cvv" do
      order.cc_cvv = "ABC!2"
      expect(order.valid?).must_equal false
    end

    it "is valid for an correct input of cc_cvv" do
      order.cc_cvv = "123"
      expect(order.valid?).must_equal true
    end

    it "is invalid without a cc_expiration" do
      order.cc_expiration = nil
      expect(order.valid?).must_equal false
    end

    it "is invalid without a valid input for cc_expiration" do
      order.cc_expiration = "Jan2019"
      expect(order.valid?).must_equal false
    end

    it "is valid with a valid cc_expiration" do
      order.cc_expiration = "102024"
      expect(order.valid?).must_equal true
    end

    it "is invalid without a zip_code" do
      order.zip_code = nil
      expect(order.valid?).must_equal false
    end

    it "is invalid without a zip_code in the right format" do
      order.zip_code = "ZIP1234"
      expect(order.valid?).must_equal false
    end

    it "is valid with a correct zip_code" do
      order.zip_code = "98103"
      expect(order.valid?).must_equal true
    end

    it "is invalid without a valid status" do
      order.status = "cancelled"
      expect(order.valid?).must_equal false
    end
  end

  describe "relations" do
    it "has order items" do
      expect(order.order_items.first).must_be_instance_of OrderItem
      expect(order.order_items.length).must_equal 1

      # describe "relations" do
      #   it "has categories" do
      #     product = products(:starbursts)
      #     expect(product.categories.length).must_equal 2

      #     category = categories(:confection)
      #     expect(category.products.length).must_equal 1
    end
  end
end
