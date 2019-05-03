require "test_helper"
require "pry"

describe MerchantsController do
  # it "must be a real test" do
  #   flunk "Need real tests"
  # end

  describe "auth callback" do
    it "can log in an existing user" do
      start_count = Merchant.count
      merchant = merchants(:jenkins)

      perform_login(merchant)
      session[:merchant_id].must_equal merchant.id

      Merchant.count.must_equal start_count
      must_redirect_to root_path
    end

    it "can log in a new user" do
      start_count = Merchant.count

      merchant = Merchant.new(provider: "github", uid: 999999999, name: "ted", username: "test_merchant", email: "test@merchant.com")

      perform_login(merchant)

      must_redirect_to root_path

      Merchant.count.must_equal start_count + 1
      session[:merchant_id].must_equal Merchant.last.id
    end

    it "doesn't log in a user with bad data" do
    end
  end
end
