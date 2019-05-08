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
      merchant = merchants(:jenkins)
      expect(merchant.order_items).wont_be_nil
    end
  end
  
  
  # describe "order items method" do
  #   it "prints a list of order items belonging to the merchant" do
  #     merchant = merchants(:jenkins)
      
  #     expect(merchant.order_items).wont_be_nil
  #     expect(merchant.order_items).must_be_instance_of OrderItem
  #   end
  # end
  
end
