require "test_helper"
require "pry"

describe MerchantsController do
  describe "auth callback" do
    before do
      @start_count = Merchant.count
    end
    it "can log in an existing user" do
      merchant = merchants(:jenkins)

      perform_login(merchant)
      session[:merchant_id].must_equal merchant.id

      Merchant.count.must_equal @start_count
      must_redirect_to root_path
    end

    it "can log in a new user" do
      merchant = Merchant.new(provider: "github", uid: 999999999, name: "ted", username: "test_merchant", email: "test@merchant.com")

      perform_login(merchant)

      must_redirect_to root_path

      Merchant.count.must_equal @start_count + 1
      session[:merchant_id].must_equal Merchant.last.id
    end

    it "doesn't log in a merchant with bad data" do
      merchant = Merchant.new(provider: "github", uid: 999999999, name: "ted", username: "", email: "test@merchant.com")

      result = merchant.valid?
      expect(result).must_equal false

      perform_login(merchant)

      must_redirect_to root_path

      Merchant.count.must_equal @start_count
      expect(flash[:status]).must_equal :error
      expect(flash[:message]).wont_be_nil
      expect(session[:merchant_id]).must_be_nil
    end
  end

  describe "show" do
    it "returns a 404 status code if the merchant doesn't exist" do
    end

    it "works for a merchant that exists" do
    end
  end
end
