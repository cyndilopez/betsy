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
end
