require "test_helper"

describe MerchantsController do
  # it "must be a real test" do
  #   flunk "Need real tests"
  # end

  describe "auth callback" do
    it "can log in an existing user" do
      merchant = Merchant.first

      expect {
        perform_login(merchant)
        get auth_callback_path(:github)
      }.wont_change "Merchant.count"

      puts "******** #{flash}"
      expect(flash[:status]).must_equal :success
      expect(session[:merchant_id]).must_equal merchant.id

      must_redirect_to root_path
    end

    it "can log in a new user" do
    end

    it "doesn't log in a user with bad data" do
    end
  end
end
