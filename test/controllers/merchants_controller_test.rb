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
    end

    it "can log in a new user" do
    end

    it "doesn't log in a user with bad data" do
    end
  end
end
